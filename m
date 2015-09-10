From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [RFC PATCH v4 3/3] vfio: platform: return device properties as
 arrays of unsigned integers
Date: Thu, 10 Sep 2015 08:39:28 +0200
Message-ID: <CAN9JPjGbVvKn9v6JRGAMAs1n6GDQ+4cNnarXaU1Es8AAd1YQLw@mail.gmail.com>
References: <1441790231-22920-1-git-send-email-b.reynal@virtualopensystems.com>
 <1441790231-22920-4-git-send-email-b.reynal@virtualopensystems.com>
 <1441831738.20355.542.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2596784895977497223=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7ACD41278
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2015 02:38:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id atlbOL5gvKBZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2015 02:38:46 -0400 (EDT)
Received: from mail-qg0-f47.google.com (mail-qg0-f47.google.com
 [209.85.192.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98C23411E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2015 02:38:46 -0400 (EDT)
Received: by qgev79 with SMTP id v79so27819205qge.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2015 23:39:28 -0700 (PDT)
In-Reply-To: <1441831738.20355.542.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Linux IOMMU <iommu@lists.linux-foundation.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============2596784895977497223==
Content-Type: multipart/alternative; boundary=001a11c0b29863ec76051f5edc6d

--001a11c0b29863ec76051f5edc6d
Content-Type: text/plain; charset=UTF-8

On Wed, Sep 9, 2015 at 10:48 PM, Alex Williamson <alex.williamson@redhat.com
> wrote:

> On Wed, 2015-09-09 at 11:17 +0200, Baptiste Reynal wrote:
> > From: Antonios Motakis <a.motakis@virtualopensystems.com>
> >
> > Certain properties of a device are accessible as an array of unsigned
> > integers, either u64, u32, u16, or u8. Let the VFIO user query this
> > type of device properties.
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
> > ---
> >  drivers/vfio/platform/properties.c | 62
> +++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 61 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/platform/properties.c
> b/drivers/vfio/platform/properties.c
> > index 8bf9c8f..625e2d3 100644
> > --- a/drivers/vfio/platform/properties.c
> > +++ b/drivers/vfio/platform/properties.c
> > @@ -70,7 +70,67 @@ static int dev_property_get_uint(struct device *dev,
> uint32_t *flags,
> >                                char *name, uint32_t type, unsigned *lenp,
> >                                void __user *datap, unsigned long datasz)
> >  {
> > -     return -EINVAL;
> > +     int ret, n;
> > +     u8 *out;
> > +     size_t sz;
> > +     int (*func)(const struct device *, const char *, void *, size_t)
> > +             = NULL;
> > +
> > +     switch (type) {
> > +     case VFIO_DEV_PROPERTY_TYPE_U64:
> > +             sz = sizeof(u64);
> > +             func = (int (*)(const struct device *,
> > +                             const char *, void *, size_t))
> > +                     device_property_read_u64_array;
> > +             break;
> > +     case VFIO_DEV_PROPERTY_TYPE_U32:
> > +             sz = sizeof(u32);
> > +             func = (int (*)(const struct device *,
> > +                             const char *, void *, size_t))
> > +                     device_property_read_u32_array;
> > +             break;
> > +     case VFIO_DEV_PROPERTY_TYPE_U16:
> > +             sz = sizeof(u16);
> > +             func = (int (*)(const struct device *,
> > +                             const char *, void *, size_t))
> > +                     device_property_read_u16_array;
> > +             break;
> > +     case VFIO_DEV_PROPERTY_TYPE_U8:
> > +             sz = sizeof(u8);
> > +             func = (int (*)(const struct device *,
> > +                             const char *, void *, size_t))
> > +                     device_property_read_u8_array;
> > +             break;
> > +
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* get size of array */
> > +     n = func(dev, name, NULL, 0);
> > +     if (n < 0)
> > +             return n;
> > +
> > +     if (lenp)
> > +             *lenp = n * sz;
>
> Why is this conditional?
>

Same paranoia as before. If lenp is not allocated, the function behaviour
is the same.


>
> > +
> > +     if (n * sz > datasz)
> > +             return -EOVERFLOW;
>
> Ugh, this isn't E2BIG or ENOSPC...
>

Ok, will be changed to ENOSPC.


>
> > +
> > +     out = kcalloc(n, sz, GFP_KERNEL);
> > +     if (!out)
> > +             return -ENOMEM;
> > +
> > +     ret = func(dev, name, out, n);
> > +     if (ret)
> > +             goto out;
> > +
> > +     if (copy_to_user(datap, out, n * sz))
> > +             ret = -EFAULT;
> > +
> > +out:
> > +     kfree(out);
> > +     return ret;
> >  }
> >
> >  int vfio_platform_dev_properties(struct device *dev, uint32_t *flags,
>
>
>
>

--001a11c0b29863ec76051f5edc6d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Sep 9, 2015 at 10:48 PM, Alex Williamson <span dir=3D"ltr">&lt;=
<a href=3D"mailto:alex.williamson@redhat.com" target=3D"_blank">alex.willia=
mson@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><di=
v class=3D"HOEnZb"><div class=3D"h5">On Wed, 2015-09-09 at 11:17 +0200, Bap=
tiste Reynal wrote:<br>
&gt; From: Antonios Motakis &lt;<a href=3D"mailto:a.motakis@virtualopensyst=
ems.com">a.motakis@virtualopensystems.com</a>&gt;<br>
&gt;<br>
&gt; Certain properties of a device are accessible as an array of unsigned<=
br>
&gt; integers, either u64, u32, u16, or u8. Let the VFIO user query this<br=
>
&gt; type of device properties.<br>
&gt;<br>
&gt; Signed-off-by: Antonios Motakis &lt;<a href=3D"mailto:a.motakis@virtua=
lopensystems.com">a.motakis@virtualopensystems.com</a>&gt;<br>
&gt; Signed-off-by: Baptiste Reynal &lt;<a href=3D"mailto:b.reynal@virtualo=
pensystems.com">b.reynal@virtualopensystems.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/vfio/platform/properties.c | 62 ++++++++++++++++++++++++=
+++++++++++++-<br>
&gt;=C2=A0 1 file changed, 61 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platfor=
m/properties.c<br>
&gt; index 8bf9c8f..625e2d3 100644<br>
&gt; --- a/drivers/vfio/platform/properties.c<br>
&gt; +++ b/drivers/vfio/platform/properties.c<br>
&gt; @@ -70,7 +70,67 @@ static int dev_property_get_uint(struct device *dev=
, uint32_t *flags,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char *name, uint32_t type, unsign=
ed *lenp,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void __user *datap, unsigned long=
 datasz)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int ret, n;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u8 *out;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0size_t sz;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int (*func)(const struct device *, const char *, =
void *, size_t)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D NULL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0switch (type) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_U64:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sz =3D sizeof(u64);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0func =3D (int (*)(con=
st struct device *,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *, void *, size_t))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0device_property_read_u64_array;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_U32:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sz =3D sizeof(u32);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0func =3D (int (*)(con=
st struct device *,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *, void *, size_t))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0device_property_read_u32_array;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_U16:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sz =3D sizeof(u16);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0func =3D (int (*)(con=
st struct device *,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *, void *, size_t))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0device_property_read_u16_array;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0case VFIO_DEV_PROPERTY_TYPE_U8:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sz =3D sizeof(u8);<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0func =3D (int (*)(con=
st struct device *,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *, void *, size_t))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0device_property_read_u8_array;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0default:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* get size of array */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0n =3D func(dev, name, NULL, 0);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (n &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return n;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (lenp)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*lenp =3D n * sz;<br>
<br>
</div></div>Why is this conditional?<br></blockquote><div><br></div><div>Sa=
me paranoia as before. If lenp is not allocated, the function behaviour is =
the same.<br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<span class=3D""><br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (n * sz &gt; datasz)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EOVERFLOW;<br=
>
<br>
</span>Ugh, this isn&#39;t E2BIG or ENOSPC...<br></blockquote><div><br></di=
v><div>Ok, will be changed to ENOSPC.<br>=C2=A0<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0out =3D kcalloc(n, sz, GFP_KERNEL);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!out)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ret =3D func(dev, name, out, n);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (copy_to_user(datap, out, n * sz))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EFAULT;<br>
&gt; +<br>
&gt; +out:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0kfree(out);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 int vfio_platform_dev_properties(struct device *dev, uint32_t *f=
lags,<br>
<br>
<br>
<br>
</div></div></blockquote></div><br></div></div>

--001a11c0b29863ec76051f5edc6d--

--===============2596784895977497223==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2596784895977497223==--
