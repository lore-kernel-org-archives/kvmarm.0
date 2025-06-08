Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145B920B1FC
	for <kvmarm@lists.linux.dev>; Sun,  8 Jun 2025 23:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426186; cv=none; b=DBRhZCzWCoDC6+ILxe1JP+oZr8sKsI+E2qJwI9cGmcbCJNmhnd9WJY3wxzs4SIFcMppVRoIQhXSAudTcqbJGuL5G5JBo4CkArFpFL6OK8IWxhapyawXj50nGbG8OSYRNBPe8P0s7tLEcddt3yQA/LcN0vY0/orRwIj9iWBCw4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426186; c=relaxed/simple;
	bh=CIQ9YYwRaWcxV9gZOomLEuovngdq15gjETsoqhAJEM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QeqLgPPpv2RzYGhkwzKi6ggxyen65xj+vhr0JsLlx/FvuJ4TCTb1yGcDV9Zx+5YzsIBzoSx5GW5sP+mREh+njI85iHl7belWT1IIi5N1DuKMZFI/ycD/LY5Y/XcI/Bl6BtPBRoqSS+uEeZ0fqmYYOoqOrYi+G+Ux/FeIwYDqHq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qb4TR9ky; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qb4TR9ky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749426184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sV7jw4zv8DF/228SxSyGWu8M2zC9Ud0L/iBvUN6Lp8w=;
	b=Qb4TR9kyau/8PCgyYwTKpTxKwTi5ot1QT8322Z7riANPO9rpWbLuaDXuKoelLcTM2SsEkW
	H1qBn+pYmNnMiOy/Po9Sb++mHZV/frzJe21OYnWp1txcwS6HnQlaqcsm/w8iKGTGuNRsWA
	p64cBJnCMU8Vxfx4sDhfVcqHV4K84zs=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-O0Xhx3kNPaS25d6B4BM62Q-1; Sun, 08 Jun 2025 19:43:02 -0400
X-MC-Unique: O0Xhx3kNPaS25d6B4BM62Q-1
X-Mimecast-MFC-AGG-ID: O0Xhx3kNPaS25d6B4BM62Q_1749426181
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-23505adcac8so32324165ad.3
        for <kvmarm@lists.linux.dev>; Sun, 08 Jun 2025 16:43:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749426181; x=1750030981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sV7jw4zv8DF/228SxSyGWu8M2zC9Ud0L/iBvUN6Lp8w=;
        b=cvNNKTScQNR1stLm8vT+NEoSf5UN7d+V9Z57ZDtgPBt/E/4TNdKU0ab31vCKzock7A
         kGDcRqDIbLYtv+bKn5gSOaiQ7eTEAQjGOVh0yfh/48Apqkk/FYeQyS1dEhsyy8gxpbja
         oA4nb0URWBGK9MxcdkVzCy2utU0bAfYUfbYSAlcq725P5Ujj+oVCu70voxFMTd07mgD8
         qo485URnfit0oUKbsYtXqV1/xa6o+DrAfxNBWN5TWVb0XK1shZY3gK/jyvRiSdiuUnTI
         h07e7hEj6EZ5lbrumtDG3+0clE/rbLFYBhE3HdQUJjpnBYv7sPT24o8SZRQAOBG6BGxf
         CVhw==
X-Forwarded-Encrypted: i=1; AJvYcCUebd0/3PYen0p9gZRh2UHaAvy6ILb5CuvVGgstH9veM4z/yfi3TZ9rH7r+jFQD3ocGgtIoEAQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0di42e1pZXvo4D6BtzzRhBJ8GSzZDU+0ic11G1xDmJB96QpxN
	8SuXyspcwzw01TNbtez38p6ukS7JmYsbJ9RuoE2iCud5ZEYGp5BnjC4IG+i+yRFq4+LZTiicGrE
	cfl1ATAzGzWqk3vrcfJnGICCIlHd6S0DsjJyV+nQaeTwOWATAsJyw4gFVOg==
X-Gm-Gg: ASbGncvp+KAhYbf33+UBq7syXgU8hw4IHCpADvg1XWV2kyva5ZlHEIA90NXRZvZbe1G
	cq1YEv6MposIbTW/0qEDq6lOi1JAsm1QgT7fOjmLIVfC+FoKitw2mnV+VRQ1btt+5w/WMQcKnAP
	jcmuAXiNmepiJxW7DPr79V6aNIczqHVtbW5qHSKrFzZPmM9tBosdDLndhyFJd13wPa3La08uIAG
	VTpgMLEDl2xNOff0tLW96/K2gJrIZQ7mbWErpaDPi08+1DL2wrDuuhf+QMqvjqjFi0K/FmAV59l
	A4SVNsLPFcAy0HH0imyJlvKE2Ivqs2wfzGi20rEP2RBpW8tRqkklSWpY8whE5w==
X-Received: by 2002:a17:903:230b:b0:234:ef42:5d48 with SMTP id d9443c01a7336-23601d82cf8mr163243095ad.38.1749426181434;
        Sun, 08 Jun 2025 16:43:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7bor77vjvj+YZaqMIThNhyNLCg9HXt8FW1PEgAUkMFTVnRH59XUdt2gBjoBPbQYitKhphEw==
X-Received: by 2002:a17:903:230b:b0:234:ef42:5d48 with SMTP id d9443c01a7336-23601d82cf8mr163242965ad.38.1749426181096;
        Sun, 08 Jun 2025 16:43:01 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-236032fceb2sm43669945ad.96.2025.06.08.16.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 16:43:00 -0700 (PDT)
Message-ID: <af2fe174-492e-4eff-9077-a450ab393ceb@redhat.com>
Date: Mon, 9 Jun 2025 09:42:41 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 09/18] KVM: guest_memfd: Track shared memory support
 in memslot
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-10-tabba@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-10-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yG73iIsdJM3MU8ikR7RpyCiXbt_fiUxqYHptvn38MJM_1749426181
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> Add a new internal flag in the top half of memslot->flags to track when
> a guest_memfd-backed slot supports shared memory, which is reserved for
> internal use in KVM.
> 
> This avoids repeatedly checking the underlying guest_memfd file for
> shared memory support, which requires taking a reference on the file.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h | 11 ++++++++++-
>   virt/kvm/guest_memfd.c   |  2 ++
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

