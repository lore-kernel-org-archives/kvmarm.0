Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5883347FC0
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558847; cv=none; b=E7L5M25DOnmtOgCpEtDboFkD4fB+ZCFrjrocQkemN5iiLxg8xDLO/pVcTxB4PWu9Yszuezu30OraoYtgXfKiHIeBrdMUNK8I4LvyYTHLegC3uggku9kGmOap8Knv1XZp7f6NLAd5kF7Z6Z9agk0N2QZc67uXoE6KB6zEDNlEhFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558847; c=relaxed/simple;
	bh=rjaNAg+z04eA9ykYVMKBTQouCXeaLXvohfjJEkPN/as=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i2+H94IbQ0fAkg3uRYTxnm519hFpw3dVEUVqB6hExGpFj7eNSv9nQTsUQJsIiHX6SKkdw71wIokbpUxkY0b4ucWbzBt/zp2BT6wVzoZZc0cCMZ8xObp586SD59DRlNv6nXxep2T/F+x8SxH8oLTDkYKqW7ScORHt/uQU54k4i0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bQ4aPz5T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQ4aPz5T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790558845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5votifnwitH8Ds1fhrux91JN6J8KXmnO59qVNlCSXwA=;
	b=bQ4aPz5Tklr+4Jix+7lUH72KJKQ7MCx9AoASNuH6G3s3cLiFiAUqezNAiX8GTqR4lgmmoS
	QlDiRmPy+2XLfQz2mKnec6YdXrVqWqrAe7OopKbizNDqO65z/cC+usIjq/Z7hlkMVE8hr6
	Tqnd6+Tbc4L0aIo1o7USGNL2wn7/t9c=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-upW5_54RMsyq4WCiacZaoA-1; Sun, 27 Sep 2026 21:27:23 -0400
X-MC-Unique: upW5_54RMsyq4WCiacZaoA-1
X-Mimecast-MFC-AGG-ID: upW5_54RMsyq4WCiacZaoA_1790558843
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-882359f93ccso716155b3a.3
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 18:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790558843; x=1791163643;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5votifnwitH8Ds1fhrux91JN6J8KXmnO59qVNlCSXwA=;
        b=pD9aKZd1YJrfTtz+nbk4C/E8ywdxSa9kT6HBKyxMY4CS46aRMtqDMJql9ZVAyKQgLY
         m5RlSEmBtnwvhfyQkAoTAhPf0dOi9kes2J4jU+m8kbeLkm4j2276Ar51bkxny8xv1l8u
         pfOhB0L9A5wJCexaoCML0lFZiPzLZQ4MlqW0OThyymhVCMwsBivfGqelzhvoZ/TuOUkO
         58Um2W+qYqD2nm6xG6pYWcJFz1SzapdECFYPz84LlrScCFODxoHN/q/zFZDPGd019bOu
         P8CWNyQA7ExNuUoQCo9uOf9lKtM0XHMqBZMyKW8+8eb3VCirIG5KD/XHHOL7mcfKhLDb
         Ou/Q==
X-Forwarded-Encrypted: i=1; AKwUvBx832f568bIpyQK2hspDs2ikX+q91QL4rDd9KX64cbzC9KzC8i0BQZNi2yeYpV/7Mhn3Hl13xo=@lists.linux.dev
X-Gm-Message-State: AFuF++k2gmybKx0rv7CSMcLZBG71XCRJP1fZU2LkCqEF7MHn4gV73IXf
	lpeuOOXjnZwAqE8AQpNuxuPbaQu3k/PNCynugMmtwMVNowh+ElAKdw5zuWoEKLOitNDMMdQow5r
	xtBjtD+xd0DK+q14sL1V1/SFk5FpqoA4Z9+AgdE3LJks3JYrehZEGnuztNA==
X-Gm-Gg: AYBFou2wZdN9VFxmRVumft3HF3fBVSfC9wVATbG3ZAtY2SAnpEwO9XFoPDwIinUgzpL
	zujHi0TKxZ26hfKwjf5LyRoZE4JaU0/jJzkSYL8efVraN1ujtvmsL/tDzval5Tw3qSYBa+bsu9l
	2kh9CyhCmTq1mTyPesoxG+8XCNz4sr2W2PcfbN2gW/4lZcHeOvZGIYVY2QGKUTdmG2IMBQUYGWm
	e/7xHA4/BIN7/NnYlXViNYbjP15OjRph/Drv2sLwJqyRLzAwEzRP+KJ6rQESsSNASVfkOysSm4N
	hm8e+2Y6XbMuoVnKBhbn+3rgeBPmNXXPHAWCMryH+VQ2B9eOdhU0fbQnEHP6r92fIzlsR4NZkvl
	LcNt/JPKnmvpIAxw9y6Wsv53J76jSWQDYSxdWHaJt1g==
X-Received: by 2002:a05:6a00:3d06:b0:869:c368:3675 with SMTP id d2e1a72fcca58-87e9aee4a61mr9245896b3a.17.1790558842691;
        Sun, 27 Sep 2026 18:27:22 -0700 (PDT)
X-Received: by 2002:a05:6a00:3d06:b0:869:c368:3675 with SMTP id d2e1a72fcca58-87e9aee4a61mr9245873b3a.17.1790558842219;
        Sun, 27 Sep 2026 18:27:22 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-882d579ca0dsm907806b3a.21.2026.09.27.18.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 18:27:21 -0700 (PDT)
Message-ID: <2c7a9780-1846-4b5d-b743-42ee1bfdda22@redhat.com>
Date: Mon, 28 Sep 2026 11:27:14 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 14/20] KVM: arm64: CCA: Add bare minimal S2 operations
 for Realm
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-15-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-15-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UZzOhPgk5xWtBf4gNaxYUXsGsNJRAFN8FEIa3OSm14I_1790558843
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
> Add bare minimal MMU operation hooks for Realms. The mem_abort handling
> is chosen as the default KVM variant. However this cannot be reached for
> Realms yet and we would need real RMI command support to make it fully
> functional.
> 
> RMM takes care of the TLB flushing as required, when the Stage2 is
> modified. So host doesn't need to do anything explicitly. RMM doesn't
> support access flags for the stage2, even for the shared IPA.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

