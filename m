Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AD83644C4
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 01:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790559026; cv=none; b=GEUeK0WAvNZW+3OJHLrEkfnG4sb5XfDzvriUGAqJycBKnlM21cm8sTgAfh7+s4lfTSlsOPtxoEz9jq1LuQwcIsHSHctK5U21GZAZz8Y9meURtiA+VTmBwys23rhUZs7DVUGL2SCu62isdtxzWk6R1Ads995U+YHEnTyxCs4ezWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790559026; c=relaxed/simple;
	bh=QlLcDcQByi/cJEHmg77m0F16fpY7R0NnpMdw+vOt8yQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EUF8nrPm7UDBi255xRsCbgGY2d1HveUvWWd+DLawrp0TUuH6K/43LHwloB0rahzUjyQ+nj/UzOPPEPfkKEv8rsci2J2xdjGoHHnUZg0ghhTmPw/YedhDyu52KyfStpgpW/XAsOUayOVHx8Lc4Eo+ZpP5z80anb8UbX2taIrRWgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3PE47pV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3PE47pV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790559019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mI4MQAkrqHNpUjr7C93Sk+aRsKdy2XPiHpFNJDV/YcA=;
	b=B3PE47pV5WLJe1TQsv67WyCivGBPj+O1rN05iqNUmSNP3SAtDeCVZ/bbW1uEc0P6ml7TQ1
	+9mPeTD/VhWkC64ejgQ5kBpL5Thvhh4AdIg4YqTqbJPiPMrL3vkLMLYSJqQddy6f22GJcM
	7aaXYpFBZZ721ziOd+DdhhmvbUoTWLc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-9FGvDNqPMj-dVpGcDQei6A-1; Sun, 27 Sep 2026 21:30:18 -0400
X-MC-Unique: 9FGvDNqPMj-dVpGcDQei6A-1
X-Mimecast-MFC-AGG-ID: 9FGvDNqPMj-dVpGcDQei6A_1790559018
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f57e31b6eso1822124a91.1
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 18:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790559018; x=1791163818;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mI4MQAkrqHNpUjr7C93Sk+aRsKdy2XPiHpFNJDV/YcA=;
        b=1A5M/G5ZB5/yVM80XVDtt4lgI7XPtGsr8ehbUqouVdVUZQKpk49rTBj2pX1RAjcpVd
         TItiQA+SUE5hjtbyaQCeRVNEFXr7QcsKExMi3Nxamz+fH+bikCcGFEaueTt5oWR5gQwo
         bacKi9fRNb8ofvYM0hs6lq8IyQVLEl8NHt4abpPPUFYuk4lpc8S6JFhA0hl9mbEa7CjA
         CR/VTOIn9aXP+I4/5BUWOEbTzT/9JlI/7Mp8+4b7r7b9AjbbBuPBoCWXDGS1pezKNgJn
         B77dHPqGSXRTsmoGNayfOT/CTYHQbha3s5qvQWRz7n6n4eTULkh4qRgUI9xm+zaG6aZ6
         pE/A==
X-Forwarded-Encrypted: i=1; AKwUvBxcvDV9y5wA5IrSY0TdA7ADz396cWM2oNdyuEbByaCWeL+n+pm//LZA+trMxLVYJJtQaZsVs7k=@lists.linux.dev
X-Gm-Message-State: AFq9FYKG7as/NqxdJFQ+2rFuke2bQ0yRwv+eiA4vVRZvIuju6MrdghVk
	WuKSrF4L3+mLFb+jaDPzG8hoPSZoTs/NwUO36E67bjmyudRGDhBKDXWeWp5G4rFhwj0WP1BzTRW
	3jR6QAfH0Zy0dBB0jnYtvjuWa2uVXbwT6UGq6OR8t52NuGCiiRGfZcOkUgg==
X-Gm-Gg: AYBFou1XlrGmU7YEDF3rRjArNBGhdh+t+pxBpdeDCgbz+kdOM0QwzO50Ef+I+uFWhVD
	+DYFPEzAwQ64mE1qN6171+PCnechg6dAxACeaLYaaO+w/RkuLIpV6sXqFz2TqpuWOXWAe9+RzL9
	mg12pt/1L9XwU81ZaE2UWu92LPCRXb6FrrA5hK8x2OiiAiwF9MW9ErCk7H7vU1qy+mmP8d5ylg1
	KCGrw9mQRpfpWBhVotGguvOhfsN3hiEfzQZkuOfdFt9iYHSLJC3K2v+SMSjLJ6A+W/ac5VWbbxb
	xLfXMWImOQSjFCPwOlf3IdK53gERuAaYbfd9bL+6HTXHXTeENUcHovPZx09T02m9kH2BLUBqx/b
	Dm45SENr34rG/Wjz2N8ubgQEDUFp0BjLLIXp3mwtVgg==
X-Received: by 2002:a17:90b:2dc3:b0:39e:6a7e:ee18 with SMTP id 98e67ed59e1d1-3a098da14d3mr9007857a91.36.1790559017551;
        Sun, 27 Sep 2026 18:30:17 -0700 (PDT)
X-Received: by 2002:a17:90b:2dc3:b0:39e:6a7e:ee18 with SMTP id 98e67ed59e1d1-3a098da14d3mr9007821a91.36.1790559017031;
        Sun, 27 Sep 2026 18:30:17 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99917besm17161191a91.14.2026.09.27.18.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 18:30:16 -0700 (PDT)
Message-ID: <98356890-80b0-47f8-bddf-75d75ce63272@redhat.com>
Date: Mon, 28 Sep 2026 11:30:09 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 20/20] KVM: arm64: CCA: Control user register access
 for Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-21-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-21-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gzDFf9M9bpe-kgg1LswgnPeKGjS16AxlVxjECo9i1yk_1790559018
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM restricts the access to the register states that the host can
> read/modify for a given Realm.
> 
> e.g., At VCPU creation, can modify GPRS (x0-x30) and PC.
>        While servicing SMCCC calls via RSI_HOST_CALL or servicing PSCI
>        requests.
>        MMIO emulation in the unprotected space.
> 
> Additionally we use the sysreg configuration to advertise/configure the
> following Realm parameters, which are required before the Realm Descriptor
> :w
> is created:
>   - SVE Vector Length
>   - Number of HW Breakpoints/Watchpoints
>   - PMU Counters.
> 
> Thus KVM also additionally allows access to ID_AA64DFR0_EL1 and SVE_VLS for
> the configuration of Realm creation parameters. We don't support PMUs for
> the Realm VMs yet, so PMCR is not exposed.
> 
> The RMM makes similar restrictions for reading of the guest's registers
> (this is *confidential* compute after all), however we don't impose the
> restriction here. This allows the VMM to read (stale) values from the
> registers which might be useful to read back the initial values even if
> the RMM doesn't provide the latest version. For migration of a realm VM,
> a new interface will be needed so that the VMM can receive an
> (encrypted) blob of the VM's state.
> 
> Reflect the above in KVM_GET_REG_LIST, KVM_SET_ONE_REG calls.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Co-developed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v18:
>   - Don't expose PMCR_EL0 to the userspace now, we could do that when we
>     support PMU
>   - Fix check patch warnings
> Changes since v17:
>    - Merge related changes into one single patch for the user set/get registers
>      I have retained the Review tags, as the code hasn't changed, just the patches
>      were merged into a single one with the same tags.
>    - Limit KVM_GET_REG_LIST to the allowed CORE registers.
> ---
>   arch/arm64/kvm/guest.c      | 63 +++++++++++++++++++++++++++++++++++++
>   arch/arm64/kvm/hypercalls.c |  4 +--
>   arch/arm64/kvm/sys_regs.c   | 28 +++++++++++++----
>   3 files changed, 87 insertions(+), 8 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

