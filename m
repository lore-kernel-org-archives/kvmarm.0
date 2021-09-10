Return-Path: <SRS0=KxuI=OA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781AAC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 18:04:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4D96611EE
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 18:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D4D96611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58ABF4B16E;
	Fri, 10 Sep 2021 14:04:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bNJmnjLYy6nS; Fri, 10 Sep 2021 14:04:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 320194B1B5;
	Fri, 10 Sep 2021 14:04:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABF9B4B1B5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 14:04:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IZboIwie0hHk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Sep 2021 14:04:10 -0400 (EDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com
 [209.85.219.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 806B14B1B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 14:04:10 -0400 (EDT)
Received: by mail-yb1-f175.google.com with SMTP id i12so5258458ybq.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 11:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FdiZIU18HRQNVcUBqI1gOpJDuHw72fPqFgD0vfSbxiM=;
 b=OftdWZEwD9jdXht+HSnlAwhydSymZg+fXMuExwKIPpWPSdPet2l673kSg8FcGtw/6d
 q/A8Jammz5TZedHA0AghaMGGChHtT4/kVWecAClUWj5q1tcoBkPQ91R8uZfezyXn1maC
 dYBLtWCRik7kgp43oQveNCvzkjyyNnCZtQRG8fAd0m1JyDBsgXnolXRZtTMW7Nd24Dm9
 /R+toReJ9Jkosf8Ny7n9oy64MKoI6hxdAt9vg8RHkQ6J5ZouUO23IUvUJGlNZsriSIUT
 y/mncKScphEyMFh6hYP3TjUIv7at+65xBbQO8YlIAu7cB6/3mLMu/squbAehr5XeI1qJ
 osVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FdiZIU18HRQNVcUBqI1gOpJDuHw72fPqFgD0vfSbxiM=;
 b=GUBP66Ot0RkP7tqaF0VsmjARRqb3wYUW7OnOG0KGB6QTdZdK1S6Yz2gDiQxqrgd6ZL
 nOQYGDtkFbfZe5eDGL1fjD/ydk+TNi6nRoTCrYMIqbxotlrVTyWycs5IvH86TklbVdhB
 mRyaRLYbUHDvM48WbPmt6BzFmADE6YOrR+DopfdDcidpHeQV5BCpJW/+1FxLcECO9+4H
 X/UKcfNKeyT/qUg9oZtsH5BDBAru+RSrGXU64Haj5l/s3ZAq8tuz8WgGbMGvAyzZC7aX
 DSBGXAebFJUAr3Qs+QU6L/yMu9gFj7Fs2aNKMCbv1hNwzgZTzlraDRlAvlwrNFZns9pi
 fxGw==
X-Gm-Message-State: AOAM530Eyzx/jLZCqYxI1ROddBbvo8UdCLStasQVho5DSnRV7ecLZwoU
 M2EvokHaErFCMAKCri0c8bT9Z4XG+/AC+nvxswQKtA==
X-Google-Smtp-Source: ABdhPJzWgdNOv8FFFa8yER05OfPRQry5w0Mk8yQAnalMrVdKBP5XCEEVprWbGAlMxK82fvaBzfD7oAiOSSVboVdVasw=
X-Received: by 2002:a25:8093:: with SMTP id n19mr12994954ybk.414.1631297049652; 
 Fri, 10 Sep 2021 11:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <20210909075643.fhngqu6tqrpe33gl@gator>
 <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
 <20210910081001.4gljsvmcovvoylwt@gator>
In-Reply-To: <20210910081001.4gljsvmcovvoylwt@gator>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 10 Sep 2021 11:03:58 -0700
Message-ID: <CAJHc60yhg7oYiJpHJK27M7=qo0CMOX+Qj9+q-ZHgTVhWr_76aA@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To: Andrew Jones <drjones@redhat.com>
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

On Fri, Sep 10, 2021 at 1:10 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 10:10:56AM -0700, Raghavendra Rao Ananta wrote:
> > On Thu, Sep 9, 2021 at 12:56 AM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
> ...
> > > > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > > > +             vcpuid = vcpuid_map[i].vcpuid;
> > > > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
> > >
> > > We don't want this assert if it's possible to have sparse maps, which
> > > it probably isn't ever going to be, but...
> > >
> > If you look at the way the array is arranged, the element with
> > VM_VCPUID_MAP_INVAL acts as a sentinel for us and all the proper
> > elements would lie before this. So, I don't think we'd have a sparse
> > array here.
>
> If we switch to my suggestion of adding map entries at vcpu-add time and
> removing them at vcpu-rm time, then the array may become sparse depending
> on the order of removals.
>
Oh, I get it now. But like you mentioned, we add entries to the map
while the vCPUs are getting added and then sync_global_to_guest()
later. This seems like a lot of maintainance, unless I'm interpreting
it wrong or not seeing an advantage.
I like your idea of coming up an arch-independent interface, however.
So I modified it similar to the familiar ucall interface that we have
and does everything in one shot to avoid any confusion:

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h
b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..0e87cb0c980b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -400,4 +400,24 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t
vcpu_id, struct ucall *uc);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);

+#define VM_CPUID_MAP_INVAL -1
+
+struct vm_cpuid_map {
+       uint64_t hw_cpuid;
+       int vcpuid;
+};
+
+/*
+ * Create a vcpuid:hw_cpuid map and export it to the guest
+ *
+ * Input Args:
+ *   vm - KVM VM.
+ *
+ * Output Args: None
+ *
+ * Must be called after all the vCPUs are added to the VM
+ */
+void vm_cpuid_map_init(struct kvm_vm *vm);
+int guest_get_vcpuid(void);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c
b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index db64ee206064..e796bb3984a6 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -16,6 +16,8 @@

 static vm_vaddr_t exception_handlers;

+static struct vm_cpuid_map cpuid_map[KVM_MAX_VCPUS];
+
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
        return (v + vm->page_size) & ~(vm->page_size - 1);
@@ -426,3 +428,42 @@ void vm_install_exception_handler(struct kvm_vm
*vm, int vector,
        assert(vector < VECTOR_NUM);
        handlers->exception_handlers[vector][0] = handler;
 }
+
+void vm_cpuid_map_init(struct kvm_vm *vm)
+{
+       int i = 0;
+       struct vcpu *vcpu;
+       struct vm_cpuid_map *map;
+
+       TEST_ASSERT(!list_empty(&vm->vcpus), "vCPUs must have been created\n");
+
+       list_for_each_entry(vcpu, &vm->vcpus, list) {
+               map = &cpuid_map[i++];
+               map->vcpuid = vcpu->id;
+               get_reg(vm, vcpu->id,
KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &map->hw_cpuid);
+               map->hw_cpuid &= MPIDR_HWID_BITMASK;
+       }
+
+       if (i < KVM_MAX_VCPUS)
+               cpuid_map[i].vcpuid = VM_CPUID_MAP_INVAL;
+
+       sync_global_to_guest(vm, cpuid_map);
+}
+
+int guest_get_vcpuid(void)
+{
+       int i, vcpuid;
+       uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
+
+       for (i = 0; i < KVM_MAX_VCPUS; i++) {
+               vcpuid = cpuid_map[i].vcpuid;
+
+               /* Was this vCPU added to the VM after the map was
initialized? */
+               GUEST_ASSERT_1(vcpuid != VM_CPUID_MAP_INVAL, mpidr);
+
+               if (mpidr == cpuid_map[i].hw_cpuid)
+                       return vcpuid;
+       }
+
+       /* We should not be reaching here */
+       GUEST_ASSERT_1(0, mpidr);
+       return -1;
+}

This would ensure that we don't have a sparse array and can use the
last non-vCPU element as a sentinal node.
If you still feel preparing the map as and when the vCPUs are created
makes more sense, I can go for it.

Regards,
Raghavendra
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
