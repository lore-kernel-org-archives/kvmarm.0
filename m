Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E677347AF6D
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391618; cv=none; b=TJEGum4/pe/WTo9ltnfcusj9aIi3jpsX+m4+95bnLaz0HYYY6NJQMaoERq9TAq5a6EuiSXbyO6eS8lgdFyuTKVDHLo+mPQ5vGJ6liys5jqhu/56CA7kwilmmweZDP8FINGZ9WdgKahyDAe4KuUR24/tKIDEyLjuY8z4vnM/JA+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391618; c=relaxed/simple;
	bh=iV9N9pxRnqDFnoZPoV8oDFagTUNdSdz4glIhIVDN00c=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=OH2yDU2odfvFmW8Dk950XnnLCPEUDfZSzLivAku4fbqK5YLmLbsReggt1wKiUyUXyXGpjh41mS7y5mqcmEBjsaRBG+CcxpAqyyswiI57zj8JS2hBrSJxIpLHcqxi/gD5N8rTgvwm7VFgMpJ9HVkSaGk1xNks1KsgXIEGghtsnaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zr7SdOYp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zr7SdOYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789391615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AYcmW+FY5vrMJcgZ0RN5PZDQ38l9zoNXFROLAsP7FLc=;
	b=Zr7SdOYp5gbU3grrRmRfRCSpV403AoGiDrisTH2y33AIcY+1JZMzGEc7xa/5F8wlhRiaUO
	mNyvTF3KCXv55zd2b+22XNYtJ3UYkBODXD7Hn/6ncubz7hoIxAg1eVghpVMZ9in/uIVwcq
	99Or6NY6zuq8AdxE3RAI1YVeJGTPQ4c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-uYViBVbgNDqGtoa-iC6dtw-1; Mon, 14 Sep 2026 09:13:34 -0400
X-MC-Unique: uYViBVbgNDqGtoa-iC6dtw-1
X-Mimecast-MFC-AGG-ID: uYViBVbgNDqGtoa-iC6dtw_1789391613
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-482e8e1ac69so2173641f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 06:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789391613; x=1789996413;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AYcmW+FY5vrMJcgZ0RN5PZDQ38l9zoNXFROLAsP7FLc=;
        b=I2o6WA8SnjQEwHTntbOI21lj3eX75Z+msjf5N3SzbID1ogT0WCR6sFhrCWZqhZ+FQS
         V+u8daBvMdyxznW/joaKV7fb28lbmv2kvPblCES4OyqsfTTd2/FIqfJHeF8+HMq/uQz6
         QW2YAbJqWxBvKj3xd2wkH+CmsvOWOpRnmlkPDjxYPlEvVnotscUkJKf4TLzs14P+8v0f
         E1qGjnlwENGUY0VyTfT8dXxz3+AV3EN1PWqosGkImz+oZG6QS/jgJuUriIXUeGhxmh7B
         XjuBLnnEQvo0gtltFL8HBNK1Dti0Dj3twZ36jHW6AGKJtzIhqUEzPXiqF9trOoKtLGwW
         Houg==
X-Forwarded-Encrypted: i=1; AKwUvBx6MlbT3fHXKrakL42kaPyy1jj3wxtjPhnfrfdsmWmc0JOidVVGqwQRndtssZHuMitvbkVp6EE=@lists.linux.dev
X-Gm-Message-State: AFuF++lSvnGvoWH7TySBWlG0q2/+ev5VczgxauqnUOVKqlJUWEF+Tg3N
	E5wT08gykEty2h+TqPnRlVky9NSJjzbfuvvGj7g8Iga9B2DOU7NeORmIqW3YJF9BqGH/srC8vdn
	A/ssiZwBXXK0QcMiJaLgxZXVzoEVwli8IjUndqloUeTOMKaDdnQ++iGm89g==
X-Gm-Gg: AYBFou3jt3DpMG2hGHO8Gs72ktFL8HvV4KMMriOy5xC1TeTqefWXqiYUPjxszZaJa/Q
	dBpmlyChNQA9Z5kmO88831hbShFwibNWDU4alJj35+F+MxtNDrBPhFRW9lQOrDWgfcYJbvplpk3
	NizoXMakhj+43H4jS+wHuAnV8PPpov//vNqvd917BJNAQ0OhmLB1rS75w+V28rsxFNnNMwrb/AL
	F8wJekBI8SRXISr14pxUKxFMA2ULAhKhb8QAwFUn8tSjurCvY9omBofwWM3lppj9anEPtt/BRui
	VQ8S8Y7OEiExBjC0m8AZwxz1Fwu5MyIAnU0CQ+j5iHOQnhGOnzQZ+UL2hEK0AY8VWBH7g++asB7
	+ndN5Hz6XXEqENozmGfb6p3CTzu2lKGbOJXI=
X-Received: by 2002:a05:6000:4696:b0:487:48b:83c7 with SMTP id ffacd0b85a97d-487048b85abmr415907f8f.4.1789391612925;
        Mon, 14 Sep 2026 06:13:32 -0700 (PDT)
X-Received: by 2002:a05:6000:4696:b0:487:48b:83c7 with SMTP id ffacd0b85a97d-487048b85abmr415876f8f.4.1789391612392;
        Mon, 14 Sep 2026 06:13:32 -0700 (PDT)
Received: from rh (p200300f6af1c8300fec44a2b8bbb173f.dip0.t-ipconnect.de. [2003:f6:af1c:8300:fec4:4a2b:8bbb:173f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32d5f1sm29032519f8f.12.2026.09.14.06.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 06:13:31 -0700 (PDT)
Date: Mon, 14 Sep 2026 15:13:30 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Sean Christopherson <seanjc@google.com>
cc: Zenghui Yu <zenghui.yu@linux.dev>, Jiakai Xu <xujiakai2025@iscas.ac.cn>, 
    Shuah Khan <shuah@kernel.org>, 
    Andrew Jones <andrew.jones@oss.qualcomm.com>, 
    Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev, 
    Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
    Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH] KVM: selftests: fix steal_time for arm64 with host page
 size > 4K
In-Reply-To: <amuaB-dZ2s3lI8NU@google.com>
Message-ID: <b734b085-3330-b6bf-064e-b0322c1a3c28@redhat.com>
References: <20260504112808.21276-1-sebott@redhat.com> <7575a845-a542-4b16-b512-aec3126f97f3@linux.dev> <335f21e5-493d-012d-b07c-2e48cc2b9aeb@redhat.com> <a6ccc7a8-488b-4454-81b1-f29dd875845c@linux.dev> <073cfbe1-0a27-015b-c688-53c186100fa1@redhat.com>
 <amuaB-dZ2s3lI8NU@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 89fizgFLdUyPUdGBf7eRDGFX5ifNtxQVJdaALqauNYs_1789391613
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 30 Jul 2026, Sean Christopherson wrote:

> On Mon, Jun 29, 2026, Sebastian Ott wrote:
>> On Sun, 28 Jun 2026, Zenghui Yu wrote:
>>
>>> On 6/22/26 10:14 PM, Sebastian Ott wrote:
>>>>
>>>> Fix the following failure when running with 16K host page size:
>>>> ==== Test Assertion Failure ====
>>>>   lib/kvm_util.c:991: vm_adjust_num_guest_pages(vm->mode, npages) == npages
>>>>   pid=873 tid=873 errno=0 - Success
>>>>      1  0x0000000000405a27: vm_mem_add at kvm_util.c:991
>>>>      2  0x000000000040241f: check_steal_time_uapi at steal_time.c:223 (discriminator 7)
>>>>      3   (inlined by) main at steal_time.c:539 (discriminator 7)
>>>>      4  0x00007fff8b57af3b: ?? ??:0
>>>>      5  0x00007fff8b57b007: ?? ??:0
>>>>      6  0x0000000000402b6f: _start at ??:?
>>>>   Number of guest pages is not compatible with the host. Try npages=4
>>>>
>>>> Fixes: fc240715fc50 ("KVM: selftests: arm64: Fix steal_time test after UAPI refactoring")
>>>> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
>>>> Link: https://lore.kernel.org/kvmarm/7575a845-a542-4b16-b512-aec3126f97f3@linux.dev/T/#u
>>>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>>> ---
>>>>  tools/testing/selftests/kvm/steal_time.c | 6 ++++--
>>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
>>>> index 76fcdd1fd3cb..cdb81f3ee4b2 100644
>>>> --- a/tools/testing/selftests/kvm/steal_time.c
>>>> +++ b/tools/testing/selftests/kvm/steal_time.c
>>>> @@ -208,6 +208,7 @@ static void check_steal_time_uapi(void)
>>>>  {
>>>>      struct kvm_vm *vm;
>>>>      struct kvm_vcpu *vcpu;
>>>> +    unsigned int gpages;
>>>>      u64 st_ipa;
>>>>      int ret;
>>>>
>>>> @@ -220,8 +221,9 @@ static void check_steal_time_uapi(void)
>>>>      };
>>>>
>>>>      vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
>>>> -    vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);
>>>> -    virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
>>>> +    gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, 1);
>>>
>>> Would vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE) be better
>>> to describe the number of pages we want to add?
>>
>> Hm, I don't think we care. This is just for the uapi checker - the vm/vcpu
>> doesn't even run..
>
> Even though we don't truly care, we can "fix" that and dedup code at the same
> time.  E.g.
>
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index bc3c62b72c58..c0256d4c4b09 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -27,6 +27,9 @@
> static void *st_gva[NR_VCPUS];
> static u64 guest_stolen_time[NR_VCPUS];
>
> +static struct kvm_vm *vm_create_steal_time(u32 nr_vcpus, void *guest_code,
> +                                          struct kvm_vcpu *vcpus[]);
> +
> #if defined(__x86_64__)
>
> /* steal_time must have 64-byte alignment */
> @@ -210,17 +213,14 @@ static void check_steal_time_uapi(void)
>        u64 st_ipa;
>        int ret;
>
> -       vm = vm_create_with_one_vcpu(&vcpu, NULL);
> -
>        struct kvm_device_attr dev = {
>                .group = KVM_ARM_VCPU_PVTIME_CTRL,
>                .attr = KVM_ARM_VCPU_PVTIME_IPA,
>                .addr = (u64)&st_ipa,
>        };
>
> +       vm = vm_create_steal_time(1, NULL, &vcpu);
>        vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
> -       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);
> -       virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
>
>        st_ipa = (ulong)ST_GPA_BASE | 1;
>        ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
> @@ -500,13 +500,26 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
>        }
> }
>
> +static struct kvm_vm *vm_create_steal_time(u32 nr_vcpus, void *guest_code,
> +                                          struct kvm_vcpu *vcpus[])
> +{
> +       unsigned int gpages;
> +       struct kvm_vm *vm;
> +
> +       vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
> +       gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * nr_vcpus);
> +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
> +       virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
> +
> +       return vm;
> +}
> +
> int main(int ac, char **av)
> {
>        struct kvm_vcpu *vcpus[NR_VCPUS];
>        struct kvm_vm *vm;
>        pthread_t thread;
>        cpu_set_t cpuset;
> -       unsigned int gpages;
>        long stolen_time;
>        long run_delay;
>        bool verbose;
> @@ -518,10 +531,7 @@ int main(int ac, char **av)
>        cpu = pin_self_to_any_cpu();
>
>        /* Create a VM and an identity mapped memslot for the steal time structure */
> -       vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
> -       gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
> -       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
> -       virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
> +       vm = vm_create_steal_time(NR_VCPUS, guest_code, vcpus);
>
>        ksft_print_header();
>        TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
>

Ugh, somehow I thought that this was already merged. V2 can be found
here: https://lore.kernel.org/kvmarm/20260914131013.60334-1-sebott@redhat.com/

Thanks,
Sebastian

