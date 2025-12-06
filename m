Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6E721ABAC
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 03:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764992333; cv=none; b=kcJK590p7CiP9Fpt6SvbleU8O+FLPi8PAGkAmfOMGj3yd4gJ4ywoO8MmRxYNRvwpz9PIN3JAlW/EWNOGHzkYlz0kZNBzXelZLd2bhXXrAAEiZLgWiO1ccywnULw8c3WoHrXJIZmgQ/n0Q+gixPmnBDfLWNAhDRHyk36KxsoTwjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764992333; c=relaxed/simple;
	bh=RPIuaxf//AbFhM1/mGaCmgPDo6nxo24jyaZnDA6G0ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qviaU2vFpiE7q1I9+sWOVziTftNobQrwHofR3LGetGVzCd1QfnFQhJfbEIVp9KW5ycByl06UER5bt+70a//ncgbkYMDERx8guUkFJPKE8TDY5eY8++iG4Y7kQosEfQJm+7aCh1aD2Po1nsAvyr1T+m4uBcTC2sqyTQeuJc29G7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=coIeJHot; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="coIeJHot"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id RXl0v5iYJKjfoRj89vDTTz; Sat, 06 Dec 2025 03:38:46 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id Rj89vvcHO8RQgRj89vemOq; Sat, 06 Dec 2025 03:38:45 +0000
X-Authority-Analysis: v=2.4 cv=aNjwqa9m c=1 sm=1 tr=0 ts=6933a545
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=ujWNxKVE5dX343uAl30YYw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=_lKBnUPEwlkEFLTacEwA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KoD1NRD0QaV+f74bc5iSUT0wwYVNJpat/RcP0vQRNuI=; b=coIeJHotksEB6dU0JU8LIyi2+L
	uaDb55h2Mt1UuG3h/KfXxkyCM9kNkUWFXfKhHQ4o8JDSD7EQAoRXlQNhy2MPsqj9G6CEDFz/Atw+9
	ZgQjnWppwz+a1nyxKyA8oa3XON37XtoLsHEsqBF7NciO4/cTYHyJsaGDdkZ1q96dXAR3vN+Ajgd8E
	26oVQjWOBLooorvXiIFmWbm5h0W8vYG/Im+2W7ub8NiQ1hVB5GfsOo4OHyrJbTvh1tDzKIt53tiIR
	QYbVpumaH0gvsFCV4zcXTBdq2yPsnMuu7hmsfqp+jYwJ4mvpvuF9UPJnj4fcmmFTX5nHWOJenYOGa
	9yhq7lSQ==;
Received: from i118-18-233-1.s41.a027.ap.plala.or.jp ([118.18.233.1]:61266 helo=[10.83.24.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1vRj86-00000002EOT-2JGv;
	Fri, 05 Dec 2025 21:38:43 -0600
Message-ID: <0018d1c0-58ec-4b31-b016-472795990923@embeddedor.com>
Date: Sat, 6 Dec 2025 12:38:14 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>
References: <20251205232655.445294-1-seanjc@google.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20251205232655.445294-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 118.18.233.1
X-Source-L: No
X-Exim-ID: 1vRj86-00000002EOT-2JGv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: i118-18-233-1.s41.a027.ap.plala.or.jp ([10.83.24.44]) [118.18.233.1]:61266
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKNimS0808CAZ1xQOyaGJKgZSZzQhkn2uTqWhKawajU3sjp40HzDT04bBZSSszLCr5JMj9ZSk0U8YmLBjHRffmc4Ouha0tbzFH2wue0FSZXR+Cc2zaZV
 vDJPAJfFVI+M4BDC2LD0s8EuvJVtXactUBg0nHeq3erkT0zXj/Mu4VR4VfxcyfobVrO9FG6+38Tm0MhSioUt3g6jCK59h9adPCY=



On 12/6/25 08:26, Sean Christopherson wrote:
> Remove KVM's internal pseudo-overlay of kvm_stats_desc, which subtly
> aliases the flexible name[] in the uAPI definition with a fixed-size array
> of the same name.  The unusual embedded structure results in compiler
> warnings due to -Wflex-array-member-not-at-end, and also necessitates an
> extra level of dereferencing in KVM.  To avoid the "overlay", define the
> uAPI structure to have a fixed-size name when building for the kernel.

Nice. Thanks for this.

> 
> Opportunistically clean up the indentation for the stats macros, and
> replace spaces with tabs.
> 
> No functional change intended.
> 
> Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Closes: https://lore.kernel.org/all/aPfNKRpLfhmhYqfP@kspp
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>

-Gustavo
