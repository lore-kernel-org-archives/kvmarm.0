Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1F3379EC8
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 18:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436695; cv=none; b=Cfd8WHlZFcghLAXkxwd4J5hpRUOo5E8ZBKnLFJTrB+UWWec76BowAE9LPerIagFB+PuijfHQasqSU6s/Q+VLkYKbXovG4StaFvlmt55PVYs/t26xQ3ir/DtcO6QBa57adz/oZeLYOPtzFPlhgykXa47wzmavQ/mf/tt/OPZRUKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436695; c=relaxed/simple;
	bh=MclfqqAOvRhjdUnW4KUPI/0nCU2GrBKsXkAWYdFV3iA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TFYhx/eMGzxRbFPcOqrP1n1N7Ur0AO/e4KUCsd2so9r8RXVO/KrRR4BjTyIrAIPFGhLezVcN3A9CyjMvGpJegCMb1cl7kFMJIAl/FwQl9jwLXVefQJSDKNp0CC+LCNEwOv5i74XOyVThCM4a02QZVXd8cmCb9Sy9I/y3fa9a4Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IzhcJDbc; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IzhcJDbc"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so236437a91.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 11:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785436680; x=1786041480; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bpb7rVnMP2yhSUFeRPzDa/SCZEbyHiuIMPgM8gQi/g=;
        b=IzhcJDbchmvaL7HWPxVWDcT7yalFN0RHPknTQJTIytyeQpUvFlkxU7vYyFmRYbjRlg
         qPzP+W/sv9M4R5C+EJrGiEQQVupUu/5zHd3Abnwd+XEl3aETHo963XdEcsuUpL4tv4BK
         ucjYNcbtdWZKfxUXqzUJTrlJ8SanTTGgfHGXje4XMaXIXQqDGPbg9cx/Q0cbJmVQMLZj
         U5gUVDH0bVJYOC1djq52U8P6b/Nl8TtSkJCJvxRgkfdOYz4no8l9VmspaKGpyIc2Vbh7
         yfq5hZqN9J2cduTqMwxg4+43Tx1RMSZ/dhPam5MVuJyaP1TS6o49cmNDQCBrEOn1M4L8
         EvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785436680; x=1786041480;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/bpb7rVnMP2yhSUFeRPzDa/SCZEbyHiuIMPgM8gQi/g=;
        b=eHub/ek/U7vgfJS5IgZETMSMJ0e+CoMK2uWyV78WWYp46hsKTqY2LDWa1usq9foLUu
         wflVFzy3C9TFAkVLCxhhg8YAsikXYXC+rytmBkmLi4dYhwwLXjlHtdtAKvpjPRe6SFE3
         kelSgtHECiUVCsimNf4JbaQFt1a7g+2lo43mMu5nuw9RckRHWr2Ef4TDZUtbETr8DQZB
         JO+5laxcaj//0T9OCP2yPHB0vrgjaifphqWdk9mjMPUHVkLq8YeCV64WIMMEEazFkCS6
         ZpsJ3zNzxjZSaDnV6ymbk+r9+QxbG3L4uMEnGcF7ktBX1TxQSIofSZHYmMwi/oRz2IKf
         Nd8Q==
X-Forwarded-Encrypted: i=1; AHgh+RqpsQLj23+xeTxoHPIKG2KnX5JRftoRgUvqeL3bzZWDU9dVCzlAqtCOWnU+k+51JJyJ6MUu/yA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHHXj20JsjIeoEIu3QJd5UU5kUnVFnYO5LYIySPYLJvb7fdQ6L
	6thR4uk0WyPjvxxtwIr2VD2WD2Pi9zlVzRbLt1/2FCmPQeHf4PM9EuEriRrbX8fZzWuk1ixlQwo
	iUo1g6Q==
X-Received: from pjon4.prod.google.com ([2002:a17:90a:9284:b0:381:127b:2e24])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c884:b0:381:3b5d:30f4
 with SMTP id 98e67ed59e1d1-38f9bd51be4mr3217997a91.1.1785436679924; Thu, 30
 Jul 2026 11:37:59 -0700 (PDT)
Date: Thu, 30 Jul 2026 11:37:59 -0700
In-Reply-To: <073cfbe1-0a27-015b-c688-53c186100fa1@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504112808.21276-1-sebott@redhat.com> <7575a845-a542-4b16-b512-aec3126f97f3@linux.dev>
 <335f21e5-493d-012d-b07c-2e48cc2b9aeb@redhat.com> <a6ccc7a8-488b-4454-81b1-f29dd875845c@linux.dev>
 <073cfbe1-0a27-015b-c688-53c186100fa1@redhat.com>
Message-ID: <amuaB-dZ2s3lI8NU@google.com>
Subject: Re: [PATCH] KVM: selftests: fix steal_time for arm64 with host page
 size > 4K
From: Sean Christopherson <seanjc@google.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, Jiakai Xu <xujiakai2025@iscas.ac.cn>, 
	Shuah Khan <shuah@kernel.org>, Andrew Jones <andrew.jones@oss.qualcomm.com>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 29, 2026, Sebastian Ott wrote:
> On Sun, 28 Jun 2026, Zenghui Yu wrote:
> 
> > On 6/22/26 10:14 PM, Sebastian Ott wrote:
> > > 
> > > Fix the following failure when running with 16K host page size:
> > > ==== Test Assertion Failure ====
> > >   lib/kvm_util.c:991: vm_adjust_num_guest_pages(vm->mode, npages) == npages
> > >   pid=873 tid=873 errno=0 - Success
> > >      1  0x0000000000405a27: vm_mem_add at kvm_util.c:991
> > >      2  0x000000000040241f: check_steal_time_uapi at steal_time.c:223 (discriminator 7)
> > >      3   (inlined by) main at steal_time.c:539 (discriminator 7)
> > >      4  0x00007fff8b57af3b: ?? ??:0
> > >      5  0x00007fff8b57b007: ?? ??:0
> > >      6  0x0000000000402b6f: _start at ??:?
> > >   Number of guest pages is not compatible with the host. Try npages=4
> > > 
> > > Fixes: fc240715fc50 ("KVM: selftests: arm64: Fix steal_time test after UAPI refactoring")
> > > Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> > > Link: https://lore.kernel.org/kvmarm/7575a845-a542-4b16-b512-aec3126f97f3@linux.dev/T/#u
> > > Signed-off-by: Sebastian Ott <sebott@redhat.com>
> > > ---
> > >  tools/testing/selftests/kvm/steal_time.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> > > index 76fcdd1fd3cb..cdb81f3ee4b2 100644
> > > --- a/tools/testing/selftests/kvm/steal_time.c
> > > +++ b/tools/testing/selftests/kvm/steal_time.c
> > > @@ -208,6 +208,7 @@ static void check_steal_time_uapi(void)
> > >  {
> > >      struct kvm_vm *vm;
> > >      struct kvm_vcpu *vcpu;
> > > +    unsigned int gpages;
> > >      u64 st_ipa;
> > >      int ret;
> > > 
> > > @@ -220,8 +221,9 @@ static void check_steal_time_uapi(void)
> > >      };
> > > 
> > >      vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
> > > -    vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);
> > > -    virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
> > > +    gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, 1);
> > 
> > Would vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE) be better
> > to describe the number of pages we want to add?
> 
> Hm, I don't think we care. This is just for the uapi checker - the vm/vcpu
> doesn't even run..

Even though we don't truly care, we can "fix" that and dedup code at the same
time.  E.g.

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index bc3c62b72c58..c0256d4c4b09 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -27,6 +27,9 @@
 static void *st_gva[NR_VCPUS];
 static u64 guest_stolen_time[NR_VCPUS];
 
+static struct kvm_vm *vm_create_steal_time(u32 nr_vcpus, void *guest_code,
+                                          struct kvm_vcpu *vcpus[]);
+
 #if defined(__x86_64__)
 
 /* steal_time must have 64-byte alignment */
@@ -210,17 +213,14 @@ static void check_steal_time_uapi(void)
        u64 st_ipa;
        int ret;
 
-       vm = vm_create_with_one_vcpu(&vcpu, NULL);
-
        struct kvm_device_attr dev = {
                .group = KVM_ARM_VCPU_PVTIME_CTRL,
                .attr = KVM_ARM_VCPU_PVTIME_IPA,
                .addr = (u64)&st_ipa,
        };
 
+       vm = vm_create_steal_time(1, NULL, &vcpu);
        vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
-       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);
-       virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
 
        st_ipa = (ulong)ST_GPA_BASE | 1;
        ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
@@ -500,13 +500,26 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
        }
 }
 
+static struct kvm_vm *vm_create_steal_time(u32 nr_vcpus, void *guest_code,
+                                          struct kvm_vcpu *vcpus[])
+{
+       unsigned int gpages;
+       struct kvm_vm *vm;
+
+       vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+       gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * nr_vcpus);
+       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
+       virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
+
+       return vm;
+}
+
 int main(int ac, char **av)
 {
        struct kvm_vcpu *vcpus[NR_VCPUS];
        struct kvm_vm *vm;
        pthread_t thread;
        cpu_set_t cpuset;
-       unsigned int gpages;
        long stolen_time;
        long run_delay;
        bool verbose;
@@ -518,10 +531,7 @@ int main(int ac, char **av)
        cpu = pin_self_to_any_cpu();
 
        /* Create a VM and an identity mapped memslot for the steal time structure */
-       vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
-       gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
-       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
-       virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
+       vm = vm_create_steal_time(NR_VCPUS, guest_code, vcpus);
 
        ksft_print_header();
        TEST_REQUIRE(is_steal_time_supported(vcpus[0]));

