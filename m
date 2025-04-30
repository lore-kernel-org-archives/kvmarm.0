Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A246E1D86D6
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 05:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745992069; cv=none; b=lEGWqqjnoavuTmQo+44UyYbXMd/L/zHDVfUH86NTRK1Q4jcuCfsTQImcfpRgEoKWF0gmbzjAP4QVOvYiMoq9Fw9LcJIIgRbI/YToh/4+YkC+pwHLhYwtlF7xDKEOe7Ibnyvb0Q0uV9pAz3U/COw6A8g6PaZQ/1QJ9kKtjB0oB1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745992069; c=relaxed/simple;
	bh=0Gj8CKa062ZMAoAEd5s2NoFzkcBqpVYig5/ML9jfLCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nw95NJhNtwbD7+XYXTGDq+y7v2gDDDU7yCo3T9CovTJviO6g2+9mTOo/6sn6BSwDhnjDk+RckLjroCl1KGpDoLPQExeG0K5niIMcxLNGrQKgqva/qnA6aR7P91v7qmubjHv+BVs622oAQGozrFtmJWzeJBKCi/OWbhPZrf74zCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jx6aVOCI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jx6aVOCI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745992065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=979akrJcal7eXFEBBeKgkEGR2Z+cXNr2mNqqWnT1LPM=;
	b=Jx6aVOCIXa0B01cJDxU4ZLcQTdhCZXkoYdm+ohunwj3YZeKU3kq0d6SCZRGEdZgPdcO3dz
	2rSXbZivZVPCI7sI0saXmgE8C47E874hxxxiV94h8eiPCjGBbbR9nSNhrTFQrgxEnXI8KK
	TyivIbvlbqTDgTdN+zzBAdGdrPdAIy4=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-WXtu4rLiN_qOgzmzkYvpBQ-1; Wed, 30 Apr 2025 01:47:43 -0400
X-MC-Unique: WXtu4rLiN_qOgzmzkYvpBQ-1
X-Mimecast-MFC-AGG-ID: WXtu4rLiN_qOgzmzkYvpBQ_1745992062
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b1442e039eeso3891783a12.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 22:47:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745992062; x=1746596862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=979akrJcal7eXFEBBeKgkEGR2Z+cXNr2mNqqWnT1LPM=;
        b=be6iPMr8AnE9Q3gM3K4A0P1mKSkyL/rzaIjN5sJJylzKrNPAl8IRjTrB5VzVpnqvVB
         X1JFBBwVWTr+fA5t5hAHj8uw2jqFlR98SrO3dudMRVW3YwDUgCNR4hGxv0xeMdE83z6C
         OaEtZqCMDNGpVN1ARtOd33d59wFYlh3srqnyY5T0XHuNdsaffGiZxZ/LCBk8dlEV56IW
         jFFX04jFtzky+VLF3FUkTCBmXBholNFJ8U+RFHAZlOInB9uUP5vIs0MPNfawj/yHOum0
         f14fK77kHSkZgv+d2K+pRbp1T7A7lclvEi8QIjeEfNkbB9o90IQy0C+eEt5d85XBHLYP
         /3fA==
X-Forwarded-Encrypted: i=1; AJvYcCUCM1yY61F9HaGqsBOZUrwikrHicusblxk0G3Hivgb9Nf2gF2zK0/7O+mchcHxYcfZW3CEMeos=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDz78Bn0akUzqaFBIwR2sQf5/5HYd8mzygsuU8Xxoz12keVq+i
	yooL2XN/vJILyIBW/TZBV8K68+BDl+TtRAGQgfCF2X+9JfpI1r5hJDNYUeNqMkvimiIaZkg3YNi
	3MVhBwWHu3Gs89V6lFJ/N0pjDl/g6X0r6PF4lJBkHFbgfHfIIIlmKNw==
X-Gm-Gg: ASbGncsRgsfczSW4FY6DBm33iCcaj4srCcqPW51At4kdA6mNhOHGvYubUjpkzBEeAcN
	6dfAOPEkI+NOyqJ4EbRQcRpbOkYH7WBM2L8JaPafKrvjsq8WUYGbwA9ZbCc47b+rQGrWePw6VXv
	lBXhdPO7o8p2OADBhuk1M4eis8JQHoLw6hDxiNXCthmrmcpZmBk5EyMjkpvrOid6KjhdcPtS9SW
	qrEbv3z9hEM7sReWtT26vPHnjgxx04l+8N02lmwdHufuJyeiJj1RpsN7EeN116xgCvl+QRSZHSL
	0hakwaLIQKKM
X-Received: by 2002:a05:6a20:6f0a:b0:203:de5e:798c with SMTP id adf61e73a8af0-20a87758d04mr2491499637.18.1745992062579;
        Tue, 29 Apr 2025 22:47:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2yvTT56xhp4nevnnTnhdd5Vxurc2bkepUSfMbuUK1rX9UIiG+hWa401GgVAzKuOXYEii5qQ==
X-Received: by 2002:a05:6a20:6f0a:b0:203:de5e:798c with SMTP id adf61e73a8af0-20a87758d04mr2491475637.18.1745992062247;
        Tue, 29 Apr 2025 22:47:42 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a3100dsm787733b3a.90.2025.04.29.22.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 22:47:41 -0700 (PDT)
Message-ID: <9c998d71-0368-4f93-ab37-7933bec9b419@redhat.com>
Date: Wed, 30 Apr 2025 15:47:33 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/43] KVM: arm64: Allow passing machine type in KVM
 creation
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-10-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-10-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b0RhW424xRR7X3RMQaw3KsHTmdK5ilWMs-VzIUoB-jw_1745992062
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Add some documentation explaining the new machine type.
> Changes since v6:
>   * Make the check for kvm_rme_is_available more visible and report an
>     error code of -EPERM (instead of -EINVAL) to make it explicit that
>     the kernel supports RME, but the platform doesn't.
> ---
>   Documentation/virt/kvm/api.rst | 16 ++++++++++++++--
>   arch/arm64/kvm/arm.c           | 15 +++++++++++++++
>   arch/arm64/kvm/mmu.c           |  3 ---
>   include/uapi/linux/kvm.h       | 19 +++++++++++++++----
>   4 files changed, 44 insertions(+), 9 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

