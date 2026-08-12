Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F86636DA0D
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 03:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786504088; cv=none; b=iFeh+aC8e5bK0x2qfTHSJT9cDaCnUrXi44sLBpAWAHdk7HcuW2zJxLjxqFHEOsA3iF+W4i9gwlbjfCEf7zyliRk3bidwpoN7x8LW+VgMEoQfvVf7q4P8zd1aMSFrvEDWjD3HHxWzdBqMy2djVfUWhEJns2MlDgbSADDNkUD/sFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786504088; c=relaxed/simple;
	bh=dwCyngrPXg1hdkiPj675xR7xZrZpa4gLsSEMPohWafc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fxw2JjBvk2P0JuIcxMdQKvtA71T/0JFBE/OF3GcvunaGEISMmlQjE5nJOBlgYCfxDS0P1yZmF3wS+F8jhwz2cehq+LbXr1SFqKYqnNLNE7Z3I/TIEe5qVj3t54FPYQxFPsiaTCK2mtdv0/iwjXgpvdgs/fib/WhRX9Qqa2Oy5sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MYC3uA4/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MYC3uA4/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786504085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fpiOMTsisd39/3xRFpTUfEaourSQhZrPCO2dxugBjZI=;
	b=MYC3uA4/AAiSF5/pTimwJdnTzh49HBiTDi9a4MqEpSZJMn1D5J/B+/rkWHhhdKabc6VhLL
	Sx6YG2D5bJ+1+PTJHaAPWuTZNS219WMDciokRRBv6KF3v6QLAQ/6ZbGxGDSMf1FfiaKlz7
	ERo1WIjM2Zhs+NauoaWSLlYNT1+IB8Y=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-EqQv8dzQMwSq0kRhfBK9Yg-1; Tue, 11 Aug 2026 23:08:04 -0400
X-MC-Unique: EqQv8dzQMwSq0kRhfBK9Yg-1
X-Mimecast-MFC-AGG-ID: EqQv8dzQMwSq0kRhfBK9Yg_1786504083
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso624159a91.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 20:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786504083; x=1787108883;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fpiOMTsisd39/3xRFpTUfEaourSQhZrPCO2dxugBjZI=;
        b=l8TRgEi0ccb/yhbQT1d8IN9YuDegUMP52zwVFss1ntZEa2ut6i+saIdMSRJGNTZ18Y
         r1wHQhZs0wLJWF6nZhWXnmaO9bpUlTDwdTmQRuz0mm7lq/Go1g+Oi7fGvCJ0HEY3L/2y
         WFbScAonFIDghnULfXno6N8sK8zBkH3Wx4fIsRv10PSC2rIwuPoMU7jV8Bt0/mo7jGaI
         F8v9pkRHkchhalu1ErXguPtXxZDdDL1nACS8xfWGrbKAoyFL7gM4LLXe2XAae5Rd/EqT
         YAIR0B3/sxVfbm+AbNFdC+J8ROFibH4pqjHbw93XiV1J3SpxzTyJRZh2erszVmgqcMaR
         9+qw==
X-Forwarded-Encrypted: i=1; AHgh+Rpc+m4HFlhvhwmAd1svUJSC3VN2eXPIlLcf3XRbCGyVaiLAEm2PEZ31YCLOXuNIxGalWHrilrM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1211qUp9OblflxqlqfMDnjcL3lD18X4bjEHAtFabIvIIlz+y9
	BJsJpD5EXQbhkHrkzeDUR7tEX6qg7pS9Hk+P6J5akb//k+f0XmJoDpmV8Ol8iKb47uv4nsXralU
	mluT7HyyodGi5DuIc1AAq1ipZYEG3XTgijfBDzAXsSRKWALpGnFkQVkvP8g==
X-Gm-Gg: AR+sD10biwVkDWjiINfJDB41pFkaVcLcrHYQ/lgKa6RA32fpVUExT0JNUTgzhhlT14i
	0murEYD56Ou4sUrT2u0efL7jHUCBIiH5+pKw2IOTNOjbxzFaS7nhZ0xEEuXOqWKan8kn7M+GnA8
	S6rHq32EaBpbfBniCpApdxvi4+/ym47iGmVqCXSRXbJhnVF3idm6bpDamzoNNLOZYPovt7KFt7m
	PKYf8s5DF8mE+vmEgzcctWWmH6/Bu3NwRBDib8iqtPKiIywxuW5chhwkzgq61HGeFckL1aR/YDg
	6hhcUt/Uk10sRYjIKWyVKxHryoCUDvMRKtrjsD4edqQ4QAeuAFvfgMEqoUQ2juR0eI29Zu3yHH5
	qf/fD98vGoSTH0GdHGDA4KvWIM2mxt4GpCFZorNzQnNE=
X-Received: by 2002:a17:90b:3cc5:b0:38f:efed:5448 with SMTP id 98e67ed59e1d1-3930128b3a4mr2076382a91.8.1786504082750;
        Tue, 11 Aug 2026 20:08:02 -0700 (PDT)
X-Received: by 2002:a17:90b:3cc5:b0:38f:efed:5448 with SMTP id 98e67ed59e1d1-3930128b3a4mr2076287a91.8.1786504082103;
        Tue, 11 Aug 2026 20:08:02 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf6d79bd6sm5309888eec.28.2026.08.11.20.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 20:08:00 -0700 (PDT)
Message-ID: <e2894206-7470-4606-b9ac-eedc8d2bdaf3@redhat.com>
Date: Wed, 12 Aug 2026 13:07:50 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <42170467-fe36-4382-867f-49bdc6a7bc9a@arm.com>
 <d0ffbcb5-0cca-4d1e-9788-6b430345fa9b@redhat.com>
 <5e86232a-89ed-40ff-89e2-9e48fbf9554e@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <5e86232a-89ed-40ff-89e2-9e48fbf9554e@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8cCaIyu4fk1nOhB9F5qHfpH-sgECTbtHo7rgytGS_wA_1786504083
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/11/26 9:12 PM, Suzuki K Poulose wrote:
> On 11/08/2026 05:44, Gavin Shan wrote:
>> On 8/7/26 8:05 AM, Suzuki K Poulose wrote:
>>
>> [...]
>>
>>>
>>> Here is a cleaned up version, rebased on to Will's kvmtool master
>>> branch:
>>>
>>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/kvm-v16
>>>
>>> (This works with the v15 of the KVM series too)
>>> Build on top of Fuad's Guest memfd support patches.
>>>
>>
>> With the following combination, I'm able boot up the realm guest.
>>
>>    tf-rmm:   https://git.trustedfirmware.org/TF-RMM/tf- rmm.git            (branch: topics/rmm-v2.0-poc_2)
> 
> 
> Please be aware that CCA KVM v15 onwards, the above branch is not compatible. You should be using rmm-v2.0-poc_3. Please could you
> confirm if this is still an issue ?
> 

With tf-rmm/topics/rmm-v2.0-poc_2 + cca/host-v16 + kvmtool/cca/v16, there is no issue
and the realm guest can boot up successfully.

When tf-rmm/topics/rmm-v2.0-poc_3 is used, the realm guest boot gets stuck as I reported
earlier. Note the host is emulated by QEMU (TCG mode).

As the following calltrace indicates, -EAGAIN is returned from tf-rmm::update_ripas()
because true is returned from s2tte_drain_pending() for the S2TTE corresponding to
IPA 0x80000000. Linux host received error (RMI_ERROR_RTT, level=3) in ripas_change().
Upon this specific error and the IPA range [0x80000000 0x90000000], find_map_level()
returns level of 2, and realm_create_rtt_levels() returns 0 without populating any
RTTs. After that, rmi_rtt_set_ripas() is re-executed and the above loop starts over
again.

   Linux host
   ==========
   kvm_arch_vcpu_ioctl_run                     // cca/host-v16
     check_vcpu_requests
       kvm_check_request
         kvm_rec_handle_request
           kvm_complete_ripas_change
             realm_set_ipa_state
               ripas_change
                 rmi_rtt_set_ripas
                   SMC_RMI_RTT_SET_RIPAS

   TF-RMM
   ======
   SMC_RMI_RTT_SET_RIPAS                      // tf-rmm/topics/rmm-v2.0-poc_3
     smc_rtt_set_ripas
       s2tt_walk_lock_unlock
       rtt_set_ripas_range
         update_ripas
           s2tte_drain_pending                // true, returns -EAGAIN

The problem is the pending-bit for RTE corresponding IPA address 0x80000000 isn't cleared
when SMC_RMI_RTT_SET_RIPAS is invoked. I didn't figure out how this bit is set and why
it's not cleared in time.

Thanks,
Gavin

> 
> Cheers
> Suzuki
> 
> 
>>    tf-a:     https://git.trustedfirmware.org/TF-A/trusted-firmware- a.git  (branch: master)
>>    host:     https://git.gitlab.arm.com/linux-arm/linux- cca.git           (branch: cca-host/v16)
>>    kvmtool:  https://gitlab.arm.com/linux-arm/kvmtool- cca                 (branch: cca/kvm-v16)
>>
>> However, the guest can't boot up and become stuck in SMC_RSI_IPA_STATE_SET request,
>> which can't completed by the host.
>>
>>    tf-rmm:   https://git.trustedfirmware.org/TF-RMM/tf- rmm.git            (branch: topics/rmm-v2.0-poc_3)
>>
>> (1) Login the emulated host
>>
>> machine$ ssh -o StrictHostKeyChecking=no root@10.26.1.240
>>
>> (2) Start realm guest using kvmtool
>>
>> root@host:~# lkvm run --realm -c 1 -m 256                   \
>>               -k /mnt/linux/arch/arm64/boot/Image            \
>>               -i /mnt/buildroot/output/images/rootfs.cpio.xz \
>>               -p earlycon=uart,mmio,0x101000000
>>                   :
>> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
>> [    0.000000] Linux version 7.2.0-rc5-gavin-gf5098b6bae76 (gshan@nvidia-grace-hopper-01.khw.eng.bos2.dc.redhat.com) (gcc (GCC) 14.3.1 20251022 (Red Hat 14.3.1-4), GNU ld version 2.41-65.el10) #47 SMP PREEMPT Mon Jul 27 02:29:03 EDT 2026
>> [    0.000000] KASLR enabled
>> [    0.000000] Machine model: linux,dummy-virt
>> [    0.000000] earlycon: uart0 at MMIO 0x0000000101000000 (options '')
>> [    0.000000] printk: legacy bootconsole [uart0] enabled
>> [    0.000000] efi: UEFI not found.
>> [    0.000000] OF: reserved mem: Reserved memory: No reserved-memory node in the DT
>> [    0.000000] NUMA: Faking a node at [mem 0x0000000080000000-0x000000008fffffff]
>> [    0.000000] NODE_DATA(0) allocated [mem 0x8ff76dc0-0x8ff7ac7f]
>> [    0.000000] psci: probing for conduit method from DT.
>> [    0.000000] psci: PSCIv1.1 detected in firmware.
>> [    0.000000] psci: Using standard PSCI v0.2 function IDs
>> [    0.000000] psci: MIGRATE_INFO_TYPE not supported.
>> [    0.000000] psci: SMC Calling Convention v1.2
>> [    0.000000] RME: Using RSI version 1.0
>> <... no more output from the guest ...>
>>
>>
>> (3) The output from host's serial console
>>
>> SMC_RMI_REALM_CREATE              12a4c7000 12a4c6000 > RMI_INCOMPLETE 0 24 0 0
>>        SMC_RMI_OP_MEM_DONATE       0 1002c7098 9 > RMI_INCOMPLETE 9 0 0 0
>>        SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0
>> SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18f85c000 18fe00000 0 0 > RMI_ERROR_RTT 2 0 0 0 0
>> SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18fe00000 18fe10000 0 0 > RMI_ERROR_RTT 2 0 0 0 0
>> SMC_RMI_RTT_UNPROT_UNMAP          12a4c7000 18fe00000 18fe10000 0 0 > RMI_ERROR_RTT 2 0 0 0 0
>> SMC_RMI_REC_CREATE                12a4c7000 12a392000 12a391000 > RMI_INCOMPLETE 0 40 0 0
>>        SMC_RMI_OP_MEM_DONATE       0 106406098 10 > RMI_INCOMPLETE 10 0 0 0
>>        SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0
>> SMC_RMI_REALM_ACTIVATE            12a4c7000 > RMI_SUCCESS
>> Unhandled write S2_0_C0_C2_2
>> SMC_RMI_RTT_DATA_MAP              12a4c7000 8ffb4000 8ffb5000 1 129f1d004 > RMI_INCOMPLETE 0 0 0 1
>>        SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 8ffb5000 0
>> PSCI_84000000                     0 0 0 0 0 0 0 > 10001 0 0 0
>> PSCI_84000006                     0 0 0 0 0 0 0 > ffffffffffffffff 0 0 0
>> PSCI_8400000a                     80000000 0 0 0 0 0 0 > 0 0 0 0
>> SMC_80000000                      0 0 0 0 0 0 0 > 10002 0 0 0
>> SMC_84000050                      1 0 0 ffffacd67d1e8000 ffffacd67d124000 0 0 > ffffffffffffffff 0 0 0
>> SMC_80000001                      80000002 ffff 0 ffffacd67d1e8000 ffffacd67d124000 ffffacd67cd5d000 ffffacd67cd5dd38 > ffffffffffffffff 0 0 0
>> PSCI_8400000a                     c4000001 0 0 0 0 0 0 > 0 0 0 0
>> PSCI_8400000a                     c4000012 0 0 0 0 0 0 > ffffffffffffffff 0 0 0
>> PSCI_8400000a                     c4000015 0 0 0 0 0 0 > ffffffffffffffff 0 0 0
>> SMC_8600ff01                      ffffacd67cfc0740 10002 0 0 0 0 ffffacd67cfb3cc8 > ffffffffffffffff 0 0 0
>> SMC_RSI_VERSION                   10000 > RSI_SUCCESS 10000 10001
>> SMC_RSI_REALM_CONFIG              81385000 > RSI_SUCCESS
>> SMC_RSI_IPA_STATE_SET             80000000 90000000 1 0
>> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000  > RMI_ERROR_RTT 3
>> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000  > RMI_ERROR_RTT 3
>> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000  > RMI_ERROR_RTT 3
>> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000  > RMI_ERROR_RTT 3
>> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000  > RMI_ERROR_RTT 3
>> SMC_RMI_RTT_SET_RIPAS             12a4c7000 12a392000 80000000 90000000  > RMI_ERROR_RTT 3
>> <... the last message repeats ...>
>>
>> Thanks,
>> Gavin
>>
>>
> 

