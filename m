From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/3] qdev: check callback takes Object **target as third
 argument
Date: Tue, 28 Apr 2015 13:47:33 +0200
Message-ID: <553F7355.2080300@redhat.com>
References: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
 <1430212683-10984-3-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9FC74ECE7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 07:39:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KM13MNK18-Qx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 07:39:22 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 479AA4ECE1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 07:39:21 -0400 (EDT)
In-Reply-To: <1430212683-10984-3-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, peter.crosthwaite@xilinx.com
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 28/04/2015 11:18, Eric Auger wrote:
> Check callback now takes as third argument an Object **. In
> object_set_link_property, we pass the property child as argument.
> We also assign the *child before the check call so that enhanced
> check can be performed in the callback. In case the check fails,
> the old value is restored and ref count is left unchanged.
> 
> This typically makes possible to do checks both on the *child
> content (for instance a qemu_irq) and also perform some actions/
> checks on its container, which was not possible before.
> 
> This is typically useful for starting irqfd setup in vfio platform
> use case.

s/typically/for example/

I can't say that "starting irqfd setup in vfio platform" is typical. :)

> diff --git a/include/qom/object.h b/include/qom/object.h
> index 4687fa1..0a7daff 100644
> --- a/include/qom/object.h
> +++ b/include/qom/object.h
> @@ -34,7 +34,7 @@ typedef struct InterfaceClass InterfaceClass;
>  typedef struct InterfaceInfo InterfaceInfo;
>  
>  typedef void (*object_property_set_link_t)(Object *, const char *,
> -                                           Object *, Error **);
> +                                           Object **, Error **);

Let's make the new argument "Object * const*", and rename the typedef to
LinkPropertySetter.

Ok with that change.

Paolo


>  
>  #define TYPE_OBJECT "object"
>  
> @@ -1136,7 +1136,7 @@ typedef enum {
>   * an error.
>   */
>  void object_property_allow_set_link(Object *, const char *,
> -                                    Object *, Error **);
> +                                    Object **, Error **);
>  
>  /**
>   * object_property_add_link:
> @@ -1168,8 +1168,7 @@ void object_property_allow_set_link(Object *, const char *,
>   */
>  void object_property_add_link(Object *obj, const char *name,
>                                const char *type, Object **child,
> -                              void (*check)(Object *obj, const char *name,
> -                                            Object *val, Error **errp),
> +                              object_property_set_link_t check,
>                                ObjectPropertyLinkFlags flags,
>                                Error **errp);
>  
> diff --git a/qom/object.c b/qom/object.c
> index b8dff43..cc9ed87 100644
> --- a/qom/object.c
> +++ b/qom/object.c
> @@ -1112,14 +1112,14 @@ out:
>  }
>  
>  void object_property_allow_set_link(Object *obj, const char *name,
> -                                    Object *val, Error **errp)
> +                                    Object **target, Error **errp)
>  {
>      /* Allow the link to be set, always */
>  }
>  
>  typedef struct {
>      Object **child;
> -    void (*check)(Object *, const char *, Object *, Error **);
> +    void (*check)(Object *, const char *, Object **, Error **);
>      ObjectPropertyLinkFlags flags;
>  } LinkProperty;
>  
> @@ -1201,14 +1201,17 @@ static void object_set_link_property(Object *obj, Visitor *v, void *opaque,
>          return;
>      }
>  
> -    prop->check(obj, name, new_target, &local_err);
> +    object_ref(new_target);
> +    *child = new_target;
> +
> +    prop->check(obj, name, child, &local_err);
>      if (local_err) {
>          error_propagate(errp, local_err);
> +        *child = old_target;
> +        object_ref(new_target);
>          return;
>      }
>  
> -    object_ref(new_target);
> -    *child = new_target;
>      object_unref(old_target);
>  }
>  
> @@ -1233,7 +1236,7 @@ static void object_release_link_property(Object *obj, const char *name,
>  void object_property_add_link(Object *obj, const char *name,
>                                const char *type, Object **child,
>                                void (*check)(Object *, const char *,
> -                                            Object *, Error **),
> +                                            Object **, Error **),
>                                ObjectPropertyLinkFlags flags,
>                                Error **errp)
>  {
> 
