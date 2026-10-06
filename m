Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4354707C
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 00:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791246576; cv=none; b=JBJYqw4tcY40bKwNB5sg0E5gg2iYzQ3+3gbYrkbncjbvN/7SqrMUXdbVZ+XwD8uutQSIE1+Y+Z6eHbz3d1cBgune1LlVfGBVR0XZNKHbeAawVQQPUzfrklefo1sdohB4JsbJ7U6KESD4l3gv0NWtkk7qWJotT2RQNH0ae86UrgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791246576; c=relaxed/simple;
	bh=Ep/O91QiOVfVW8jwrv1LXJ3OUte/E8KeD2kAa4PCIvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uta71KbOTuxk8EhKsXHoXqvUvhJDAWc3rHRpAcGqNkfeKhi07cq2L0JyLjVUH4pE6A4K2Ye4f+D0cT13iDDJ+Egd7nDgPp8Mdao4fgB1PH5ybky3bC/VGKCNHfN/TBy04FbrDUJ9l2hShslAund+xStoElwWNnSyMaHiI5dRaMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QRLnmnGw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QRLnmnGw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791246569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2dKXjEUftIgp77OKHDO3ncsIawS7cJdjkrLy6a3G9XM=;
	b=QRLnmnGwKzFAaT8TsycLZHXksox54J1PGNmZuPsldPlr8VWPQ7YK3B/c6tOK27PK4aPK/w
	0ACISL7Ulvo451ZLZxNTS7nnWS//AwBXNgKP43YJ+5mXPymhT6GwejiQWxWu+2Swf1ATEv
	7S22NUfzTCVzhjCq/5eBtWdMTwBwde4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-0IRqEIxgN3iffnbxKEhDKA-1; Mon, 05 Oct 2026 20:29:25 -0400
X-MC-Unique: 0IRqEIxgN3iffnbxKEhDKA-1
X-Mimecast-MFC-AGG-ID: 0IRqEIxgN3iffnbxKEhDKA_1791246563
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3a7ab1ca9f4so1955691a91.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 17:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791246563; x=1791851363;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2dKXjEUftIgp77OKHDO3ncsIawS7cJdjkrLy6a3G9XM=;
        b=WestbT47z+WCc8LOZ6epSbYunt5gqXmAMBCxYTQWsKTWDrQDSXWc+cW5QYJSNiHARN
         iqqZglxDfnhri1pprzW11xNuGcYROSEw0FnsaGtcM9apwV59gfIt39rv2g4nakuBbg7U
         hd2/Hmvia8ohtY+bUbV9/6gtCU8DIT62KvERaVvbCSOG2ZVJH4TjSnK1ZF2dN0JMTZig
         6SZhBHNUQyvY9+618kn3i44cXcgs6csCu6F/q1hgNQFJTczuvXt4acie9mgs3jLX1lJI
         KmL820gKMI1dEyJiV2HAyl1CfO6L2+1o4dAypjPvkrAG9Rt14jvkvdWNx8uosRpO1C3h
         RzWA==
X-Forwarded-Encrypted: i=1; AKwUvBwQlqC2U/KtP4Cb4hrivxYTSwKDjDa3UO9nXCf70mq0QBWV9K6E/2bWp0M2cu/0Hs+xSidikWY=@lists.linux.dev
X-Gm-Message-State: AFq9FYKxV1Kj0qoFW79UQIF+ncV+TcG5t73AI3qbcZJ+GFWMJcjoKR/U
	Sbn82TUkznbPdA5ioOsTFjB95osciY8vaEH14Q8Bygy5Tch1JlGL+nuKl0u+1yjaQD0w6xKGhOJ
	dNxNh0shzaTSlHrDP0eEovFFLKTvaRBn7+PKjRGzcbNhwiq6fm9L8vLkKyA==
X-Gm-Gg: AYBFou3hNzEPoG0b3CcjMWFnWZE2fUmniMfKzqjCOVJM+Thu0hfjQn0+Dpr5719ZgBQ
	SMCvafiS1me2EqM1f9f1B3Iy6aAp42PGtbHiXjWk86X/dcJDxEd87C+Upnq6wQvwxvRz7B3fIn7
	rIA0cyyEpSLOGVTXIeyc4VU4Dg9QtRcJWbf0/IZSzTjzl197aIQcY1UL0z/ORX/Em7+qwg4k6eJ
	qOYRbFgVvqSOSKEmw7lGKt1exhaDaR/IcGRRIg/pWMC22Ch8StDIXTJLyALVO+IKm4Izq15OPzh
	zpppHUIlio2vmjW/yddKGgtt8VTiATElIgG6wbNkho0oKzmooPj3uS4ccPcp5wL/Ou1jvIbFsZs
	0+bbU4i1VY5Pms+UH958B0rOFt3LEHKSXn6V5tbsGeQ==
X-Received: by 2002:a17:90b:164d:b0:3a8:163b:b06b with SMTP id 98e67ed59e1d1-3a8163bb193mr3223739a91.57.1791246563186;
        Mon, 05 Oct 2026 17:29:23 -0700 (PDT)
X-Received: by 2002:a17:90b:164d:b0:3a8:163b:b06b with SMTP id 98e67ed59e1d1-3a8163bb193mr3223706a91.57.1791246562693;
        Mon, 05 Oct 2026 17:29:22 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8533abe0asm1954324a91.1.2026.10.05.17.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 17:29:22 -0700 (PDT)
Message-ID: <9536a477-3d66-471b-b58a-b941e4a372fc@redhat.com>
Date: Tue, 6 Oct 2026 10:29:13 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 06/23] KVM: arm64: Don't call vcpu_set_pauth_traps for
 pKVM host
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
 <20261005090754.2140522-7-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-7-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AhgqRPivcofBdku9WBTvCfq3Hj7-J5FXSsvqJ9CTqr4_1791246563
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> vcpu_set_pauth_traps() bails out and does nothing for pKVM hosts.
> Clean this up by moving the is_protected_kvm_enabled() check to the
> caller, in preparation for adding VM specific vcpu load/put callbacks.
> 
> While at it, do an early return if the vcpu doesn't have ptrauth.
> 
> No functional changes
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v19:
>   - New patch, since addition of this to the Refactoring patch makes it a bit
>     more bigger and harder to review
> ---
>   arch/arm64/kvm/arm.c | 52 +++++++++++++++++++++++---------------------
>   1 file changed, 27 insertions(+), 25 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

