Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789A8A95E
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 00:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791244961; cv=none; b=JViI3k/s4IolG6TNbfx4aAgqDU/dh1VUOxm41AAPUQq+0GYskfHGpGYkqYc2qKG27ijuyloW5ygbFg0wUfW4aY9Bt1h+wI3IrwZ4LUwylkvu9DeJ//lHGY1szPI5Ab/r57Ri/FhlBXoQ0UboPCVznW2dGxswd4lJDcKCIz7diWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791244961; c=relaxed/simple;
	bh=bbI1GlrUdF/ahNCG52V/oWZizEAOPQOpaRP4fBVF3RY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YYHxTQ4eg7MmzN4lx4WyFVB6xnVwkIzohnReFfVzb7gcx1QJAN7nziXPWQ6FuzfO70QB2t36EKmEVIjWp+eZhR2G3yihBg2E8L3bBRvdyktOkkVO++I9BNnFb5XIFoV1uyC6Hl/ROqZnfleuq9UuvRr6TcrV+6Z0iq5UjCUGwYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HZrDvHx7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HZrDvHx7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791244958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDFj6k/aDmm3juPYr/fQM/Yto+7HWelNY9uNTEiKbGU=;
	b=HZrDvHx7o2DVQPytjsKqQnQRzDRDzQwlHln09y7C24935MV83DYjNdPtZPjAofwcj+uZYd
	td3cHUyVVDeROmmR4BZJJAnZbD858plOR+RnRJw4X/PeCuHFIEfhRMKFNyQBWtNKSc+iTa
	T/JVm10KrUbjpxNGBwjWdRebUsPWjmg=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-0yBtKtgJMx6UC9xDSlX1_w-1; Mon, 05 Oct 2026 20:02:37 -0400
X-MC-Unique: 0yBtKtgJMx6UC9xDSlX1_w-1
X-Mimecast-MFC-AGG-ID: 0yBtKtgJMx6UC9xDSlX1_w_1791244956
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3a4f7eb79f2so2235452a91.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 17:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791244956; x=1791849756;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PDFj6k/aDmm3juPYr/fQM/Yto+7HWelNY9uNTEiKbGU=;
        b=si7jjr+RABIVtyUp+xDyFKU9W0oYmbu17DmQDZgPe1pL7Jhrwk3yLkViCBdbwvV1ZN
         juBZ85IbU0DCAzmmJYXW3/kfWRDGJqbghKwFv0VgFyRoIZ/6MLNBOTIbvRaOZOf9nRfx
         VO0gWHXZlUfCGc4kvMEN9ER9VN1d+QGWfBa3MBBBIqhlL1wzPIrfYFFZF1ezRxdF6oML
         Io8G5XamIMfQN4Z6agKxIFZDfxks3Al5uDAj916lhenKxlUn1kfbCVVH9o7yjWrvNlrf
         ZNHsMzDDQvYpOCgLcK8Uh0PIWg8yRSR7BIBmEhRRMPtL6n0lg3zqtPWqRVGxgaVWimzd
         C0GQ==
X-Forwarded-Encrypted: i=1; AKwUvBzzSFwbuj0VXTyaSESE+eWMAZCBfsKGZh2nvYKMHjHlIhVz3U63T4vqs//hxvoNSoHfHTr1TAU=@lists.linux.dev
X-Gm-Message-State: AFq9FYLj7C1PtmTekTLjQLc4q2MrYPxaxNBZzOSARuPMRxyq2qkOTabi
	70Vp+vz3L6LuW03bOFNa+lf2shAfFLa2mNINX0reZqmZdwXbo+G2mI61xee5NQTuJ+SBG2oh2Ej
	OjXMimwdnw5pzaA9/dwuOQChOqZpanDWCslGKNT+pfwHEbXsSbh4J9F8oAA==
X-Gm-Gg: AYBFou3otI0jWmk5UVPEDqy6T8O/AZeB9/XA3/rDR7bSz9IrAHpM5hsZhtotZZhCJT9
	0ktsdpzSRZoRLde0CSBtrcT6ZykryZIOtxVMk32fTEBiGASJqXzUn7Y54nzN9xkKRZxLI/q2KnW
	rm21Lylkd2MDNtdLXOqDy0jYTfP25cVkMJOegJNsGIrKLM5wjORIiVEzSLtLpncrrnj9U2hKGqg
	k1rrr5AVip0rok7GmehDmgpDR20AYhSd4fyLlZ+eTqg9h2saLS7I7zF6Qv3L7NPNO5JZBcaq9Up
	x/vA6Tp5Ilg7YN8yzOGIi4OO9FQ0FLIT/PiqBu5lAJ4/861DPEcKcPqKxUJ+7dO0sHJKb5poaTL
	18e2aqln63Qn4jNFngPpnO3NxXLUXLP4gffCw74YaPw==
X-Received: by 2002:a17:90b:4c05:b0:3a4:ba6e:65c9 with SMTP id 98e67ed59e1d1-3a6ce963ad0mr5001516a91.59.1791244955777;
        Mon, 05 Oct 2026 17:02:35 -0700 (PDT)
X-Received: by 2002:a17:90b:4c05:b0:3a4:ba6e:65c9 with SMTP id 98e67ed59e1d1-3a6ce963ad0mr5001495a91.59.1791244955239;
        Mon, 05 Oct 2026 17:02:35 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a85436fb54sm1801682a91.10.2026.10.05.17.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 17:02:34 -0700 (PDT)
Message-ID: <0fa5d03c-9e6c-4d81-a0de-e7aafc34918f@redhat.com>
Date: Tue, 6 Oct 2026 10:02:25 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 01/23] KVM: arm64: protected VM: Handle user writes to
 CNTVCT_EL0/CNTPCT_EL0
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-2-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-2-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ldtfR9htFKrsXCpF1AlXNknFqKI7PEXL8OszRrx_c6o_1791244956
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> Protected VMs doesn't allow setting offsets for virtual and physical
> counters, as the offset is always fixed to 0. The VM ioctl is filtered
> out based on the cap. However we don't prevent the userspace from trying
> to write to the CNTVCT/CNTPCT registers. This would lead to KVM triggering
> a WARN() in timer_set_offset() as the vm_offset pointer is set to NULL.
> 
> Fix this by always "fixing" the timer offsets to 0 and marking that the
> timer offset is set in the kvm->arch.flags at KVM init time for protected
> VMs. This prevents the access to the VM specific vm_offset at low cost.
> A userspace writing to the CNT*CT_EL0 would observe success, without
> any real effect. This is cleaner over spilling "*_is_protected()"
> checks and "matches" what we really do in practise. i.e., always run
> with "fixed counter offset of 0".
> 
> Reported by Sashiko
> 
> Link: https://lore.kernel.org/all/20260908164641.416911F00A3A@smtp.kernel.org
> Fixes: f7d05ee84a6a ("KVM: arm64: Prevent host from managing timer offsets for protected VMs")
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   Changes since v19:
>    - Fix typos in commit description and explain why we choose the approach.
>    - Improve comment in the code
>   Changes since v18:
>    - Retain NULL vm_offset for protected VMs to avoid host tampering with the
>      offset.
>    - Moved the flag setting into kvm_timer_init_vm(), where it should have been
>      in the first place
> ---
>   arch/arm64/kvm/arch_timer.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

