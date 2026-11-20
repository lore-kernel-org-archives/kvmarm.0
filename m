Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795216220;
	b=T4oFisKR8qWkHCdh1OYi56TqdhRMRPpCW2yYHzO4VEEooOJezdU2NQUkQb6vLb2wZMTD
	 Q3+AoQ9jH9V29UpRrVvOOzb0QuVsrP1VfH7DHx+hd1vAYJeszwbP48sbBl0GBv3j8SIRB
	 z3GGQMCDIqWlOiiGx+Wgcy/k1FR4xLfAtaW5d9PJUOczgGe+TOMW6etQD7995/3O1Bmp+
	 uflSwr0wWxCRCSHaZoQHI0UYY0ghZlG0YkzTVdiYqAn7hX6NDgHgnZIew+/Uz3XPakF58
	 1v9rQkerJCtj3azE4apoUQ2Fz08C+xc/oLVxdNjjVtlNEWu7gujHnEob6ZoQqKZVneg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795216220;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=tjkEaKVx0EkLFfCfrBHhfTQA5sv8oXwqq+8kKvrMx3s=;
	b=njPDmBTtI99IyszSjtUejUQDUE9dgTQ/G5MJJQgWBOGdrCdpOxgxd0gNHA2PLqakMBCY
	 kI+0/EBPFyTNu9hDsuL2xjzWMSmNYi7g5UgkHDN0GSXXgIT4w0ulUG66JgGmr1pmEL5/2
	 qCONuPDGJczuRxcAohQFqiXoiYRlDrWCJMdmEXIqTsTG0jzbk+rmHOsQj3+onpSBhdhEh
	 8xQaW9l/Ipt+aj2C6VthMULWuk6EgCcPNaKI2a7ZcygvG2aGHli9XtR9HQBJLI7lDzYen
	 AvS6Lh2I1fSoFrZnO7ZhDtDKzVMbd5MIZktH9GuNpCXdFBHavfh22LY6CnGMYQ9Bzsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A7dc0x1k;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D79606A6A4
	for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 23:10:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40D79606A6A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A7dc0x1k
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4e937c5bd4fso1199096b6e.2
        for <kvmarm@lists.linux.dev>; Fri, 20 Nov 2026 15:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795216219; x=1795821019; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tjkEaKVx0EkLFfCfrBHhfTQA5sv8oXwqq+8kKvrMx3s=;
        b=A7dc0x1k4iKuK25KPAEOTbkDwZENwCaJ8ZY28x4d5vLsrUP9BiJ7dyyJu8i7DQ2dgE
         t2RAKZ+3xKY5cPRuUKmbbDk8/CmZIIVuEsJFrPGwsD4FuTbseLFe/O5VgNrfxIZeVXuk
         o5cefkvtlYel0+9cu0+gHbQH8TVsVOgUJfz+fBEhHCWL14DQqvpyUBtJ0tpLsL16AxOa
         rkWNe+xLjMvoArpiS8yBZqBf8rxfmgiiyEY52ueK1KYyNGwDdq2aQ6Fht6vldlsdg+fz
         0yXQMgiggcmkSURxFVpHxlXKVPV9eIS4xSyLab7j/qtXbginWtkmF/DptwOs3SVbsn19
         iXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795216219; x=1795821019;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tjkEaKVx0EkLFfCfrBHhfTQA5sv8oXwqq+8kKvrMx3s=;
        b=saVk4Z4a4DCWpY3mEqh09OHiLQ3wwibjdGrONXSPsNjqeALev3Rd/gLfRMLUMbB+qM
         OkqCxqsZhgW1fPnT3n/nun+k5YjXTrnd/Ma/HREQO7arc2ot4DHJ3RzKl5fo0ft4ypB8
         X8BAJcRfn0iI5xqwh8mjto61EZONbfYlQ2v7zhfwSpRgaOTffsvlA3p6R1uxrIbF+B8q
         nfUvbKucgWwsrblPFtucUyrR6dhWxElvzFLJsb1KAxeuO4BtXA1DAqgZEMY8PxNcEqc7
         DeRL8MC6YvnOQzD8iOR7zEmJrSnbQ0/BNgOc8NaczaTMoSsMgw3fJ2r8P6QKR4uYmTZW
         yd0Q==
X-Forwarded-Encrypted: i=1; AL+hErHA9SfkK8ayCgzi6LhNZd/lDXTGMFthJV+LUnUHp7U4cj15Nzc7NgtjaKFdzlpHhxF8ToogT+8=@lists.linux.dev
X-Gm-Message-State: APuU4Z++VqIFr5pHE7InvRA5dsAdcb/DpHoiGUOnzMNbLakmDnllfFsf
	gcwS0FeZyAjVsNnJqYqU1Ymn2h6eki7+G2ufxYCdypBzP+A9t5GjiVcaOs5xss7QWMSyDYALdFR
	Tr4rN5YQW2SI8HFygfxHF/UR/sQ==
X-Received: from iobcd11.prod.google.com ([2002:a05:6602:428b:b0:9c0:11e6:874e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6615:b0:4cb:b6dd:2fe2 with SMTP id 5614622812f47-57a06a10f8amr5107904b6e.4.1795216218901;
 Fri, 20 Nov 2026 15:10:18 -0800 (PST)
Date: Fri, 20 Nov 2026 23:10:18 +0000
In-Reply-To: <87cxrz92nu.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185105.626343-1-coltonlewis@google.com> <87cxrz92nu.wl-maz@kernel.org>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120231018.1148621-1-coltonlewis@google.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix guest stage-2 mapping leak on
 sub-block unmap
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Steffen Eiden <seiden@linux.ibm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 20 Nov 2026 11:13:09 +0000, Marc Zyngier <maz@kernel.org> wrote:
> I stopped reading here. Please come back with an actual description of
> the problem that you will have produced yourself, or provide the
> original LLM report (it cannot be much worse than the above).

Sorry about that. I will clean up the slop.
