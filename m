Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13975C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 07:25:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63EB361040
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 07:25:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 63EB361040
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D31374B1C7;
	Mon, 13 Sep 2021 03:25:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5Vr5HvLDfk07; Mon, 13 Sep 2021 03:25:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D1B64B134;
	Mon, 13 Sep 2021 03:25:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D4484B10A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 03:25:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8P4EAP61D4nw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 03:25:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB8B54B0FB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 03:25:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631517950;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ycK/tCqEmqie6iTs/9nBScnQKNEMyPZZHddjJC00ddA=;
 b=Nszw7igIwXv8MotuBMueU66EOUPlva4uMv3IcRYJ2G9/yRhvVsSyJkSnrAP7RpEZNhlU8w
 aIf6WBOIV2tRBpzROoGKFFUCg9T5OWGI6NILnIA0epoHFync+H98pxXHgENi5PoHormZ8q
 3CGDVi7rAIhQ6YCpiqJVKDtcnZ6KK7o=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-wLdEIfKRNqKwgLaOqn5T6w-1; Mon, 13 Sep 2021 03:25:49 -0400
X-MC-Unique: wLdEIfKRNqKwgLaOqn5T6w-1
Received: by mail-ed1-f69.google.com with SMTP id
 g11-20020a056402090b00b003d114f9cb8aso2024454edz.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 00:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ycK/tCqEmqie6iTs/9nBScnQKNEMyPZZHddjJC00ddA=;
 b=MExQ/g1jVwdk5sprZ8c9DvNYp737TkJfH5syKsDFMI5np0g5GPgKZJd9bHhtukn8NT
 0k2emFnb7ySW2TqAihwLU8QPo5JWPoqpvfHPiYtiWgS9PxCmK5A817zG67l3xb0SIcPU
 l8EPA8dw8vC5HV4yfjCfnSXyaDMT+6T3NcopFD4hEIVsomPRPnnzCN3N3yhptROjk9iB
 hK80pAj5sZaRTF/6wZSdKPHsv9eu/Xmjlhz1jrrIvy1m7fkSzQKW2qpGlcSRgCtKuEsY
 Krcwx6WK2v0zWFDcjbGL4d2D2KAx4ZnA0cMmBgfQm8+UrQ626zLcWL0sKxtp5L+4SKmz
 1tww==
X-Gm-Message-State: AOAM533g+gQO7L71kOunGihIa8/nI+yh4oNPCpnIVTqCfG684To6Rz5d
 AdEHX+dfKsBrJAtEAkJxUNNTmrL6F1XLOmuhw/9y+d8zi4nhLvbPuJfKxtuNe/HGQ94XR2Zt9sT
 vGVJHh31aUXxVz9CXrrJdq/Hf
X-Received: by 2002:a50:d4dc:: with SMTP id e28mr11571603edj.106.1631517948189; 
 Mon, 13 Sep 2021 00:25:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNxTQ2vLqD78w1qZ/yyGrwNlAgo4kC8ZoLROpW9R1ep9CmZ5X0HutmNcr1ZAX/1oPEj6kYKw==
X-Received: by 2002:a50:d4dc:: with SMTP id e28mr11571587edj.106.1631517947927; 
 Mon, 13 Sep 2021 00:25:47 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id m10sm2962374ejx.76.2021.09.13.00.25.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Sep 2021 00:25:47 -0700 (PDT)
Date: Mon, 13 Sep 2021 09:25:45 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210913072545.vmmlejgg6jtsz4pm@gator.home>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <20210909075643.fhngqu6tqrpe33gl@gator>
 <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
 <20210910081001.4gljsvmcovvoylwt@gator>
 <CAJHc60yhg7oYiJpHJK27M7=qo0CMOX+Qj9+q-ZHgTVhWr_76aA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHc60yhg7oYiJpHJK27M7=qo0CMOX+Qj9+q-ZHgTVhWr_76aA@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Sep 10, 2021 at 11:03:58AM -0700, Raghavendra Rao Ananta wrote:
> On Fri, Sep 10, 2021 at 1:10 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Thu, Sep 09, 2021 at 10:10:56AM -0700, Raghavendra Rao Ananta wrote:
> > > On Thu, Sep 9, 2021 at 12:56 AM Andrew Jones <drjones@redhat.com> wrote:
> > > >
> > > > On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
> > ...
> > > > > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > > > > +             vcpuid = vcpuid_map[i].vcpuid;
> > > > > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
> > > >
> > > > We don't want this assert if it's possible to have sparse maps, which
> > > > it probably isn't ever going to be, but...
> > > >
> > > If you look at the way the array is arranged, the element with
> > > VM_VCPUID_MAP_INVAL acts as a sentinel for us and all the proper
> > > elements would lie before this. So, I don't think we'd have a sparse
> > > array here.
> >
> > If we switch to my suggestion of adding map entries at vcpu-add time and
> > removing them at vcpu-rm time, then the array may become sparse depending
> > on the order of removals.
> >
> Oh, I get it now. But like you mentioned, we add entries to the map
> while the vCPUs are getting added and then sync_global_to_guest()
> later. This seems like a lot of maintainance, unless I'm interpreting
> it wrong or not seeing an advantage.

The advantage is that you don't need to create all vcpus before calling
the map init function. While it's true that we'll still require a call
after adding all vcpus if we want to export the map to the guest, i.e.
sync_global_to_guest, we'll never have to worry about the map being
out of synch wrt vcpus on the host side, and there's no need to call
sync_global_to_guest at all when the test needs the map, but the guest
doesn't need to access it.

> I like your idea of coming up an arch-independent interface, however.
> So I modified it similar to the familiar ucall interface that we have
> and does everything in one shot to avoid any confusion:

Right, ucall_init does call sync_global_to_guest, but it's the only
lib function so far. Everything else exported to the guest must be
done explicitly.

> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h
> b/tools/testing/selftests/kvm/include/kvm_util.h
> index 010b59b13917..0e87cb0c980b 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -400,4 +400,24 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t
> vcpu_id, struct ucall *uc);
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
> 
> +#define VM_CPUID_MAP_INVAL -1
> +
> +struct vm_cpuid_map {
> +       uint64_t hw_cpuid;
> +       int vcpuid;
> +};
> +
> +/*
> + * Create a vcpuid:hw_cpuid map and export it to the guest
> + *
> + * Input Args:
> + *   vm - KVM VM.
> + *
> + * Output Args: None
> + *
> + * Must be called after all the vCPUs are added to the VM
> + */
> +void vm_cpuid_map_init(struct kvm_vm *vm);
> +int guest_get_vcpuid(void);
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index db64ee206064..e796bb3984a6 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -16,6 +16,8 @@
> 
>  static vm_vaddr_t exception_handlers;
> 
> +static struct vm_cpuid_map cpuid_map[KVM_MAX_VCPUS];
> +
>  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
>  {
>         return (v + vm->page_size) & ~(vm->page_size - 1);
> @@ -426,3 +428,42 @@ void vm_install_exception_handler(struct kvm_vm
> *vm, int vector,
>         assert(vector < VECTOR_NUM);
>         handlers->exception_handlers[vector][0] = handler;
>  }
> +
> +void vm_cpuid_map_init(struct kvm_vm *vm)
> +{
> +       int i = 0;
> +       struct vcpu *vcpu;
> +       struct vm_cpuid_map *map;
> +
> +       TEST_ASSERT(!list_empty(&vm->vcpus), "vCPUs must have been created\n");
> +
> +       list_for_each_entry(vcpu, &vm->vcpus, list) {
> +               map = &cpuid_map[i++];
> +               map->vcpuid = vcpu->id;
> +               get_reg(vm, vcpu->id,
> KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &map->hw_cpuid);
> +               map->hw_cpuid &= MPIDR_HWID_BITMASK;
> +       }
> +
> +       if (i < KVM_MAX_VCPUS)
> +               cpuid_map[i].vcpuid = VM_CPUID_MAP_INVAL;
> +
> +       sync_global_to_guest(vm, cpuid_map);
> +}
> +
> +int guest_get_vcpuid(void)
> +{
> +       int i, vcpuid;
> +       uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
> +
> +       for (i = 0; i < KVM_MAX_VCPUS; i++) {
> +               vcpuid = cpuid_map[i].vcpuid;
> +
> +               /* Was this vCPU added to the VM after the map was
> initialized? */
> +               GUEST_ASSERT_1(vcpuid != VM_CPUID_MAP_INVAL, mpidr);
> +
> +               if (mpidr == cpuid_map[i].hw_cpuid)
> +                       return vcpuid;
> +       }
> +
> +       /* We should not be reaching here */
> +       GUEST_ASSERT_1(0, mpidr);
> +       return -1;
> +}
> 
> This would ensure that we don't have a sparse array and can use the
> last non-vCPU element as a sentinal node.
> If you still feel preparing the map as and when the vCPUs are created
> makes more sense, I can go for it.

Yup, I think that's still my preference. We don't really need a
sentinel node for such a small array. We can just do

static struct vm_cpuid_map cpuid_map[KVM_MAX_VCPUS] = { [0 ... KVM_MAX_VCPUS - 1] = VM_CPUID_MAP_INVAL };

to ensure all invalid nodes are invalid. After a full loop
if we didn't find a valid entry, then we assert, which easily
supports a sparse array.

Also, please don't forget that guest_get_vcpuid() can be common for all
architectures. We just need an arch-specific call for get_hw_cpuid().

Thanks,
drew

> 
> Regards,
> Raghavendra
> > Thanks,
> > drew
> >
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
