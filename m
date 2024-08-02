Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F1E1DF67D
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 11:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722596596; cv=none; b=VBp3+y6IQIqeBCzNoH526oEU3+W4aenf+Q0v7T91M9ydRxCFroZ/Rx6WyPH7IRi6z60GZWBToxh3ILtUogjTJceXCf3q5ZOMqN1A4jGiAYdnQlHcVrheT9c7hInyr+kRUL/JLSfQr/cDQLGazwW93AGaTut6YLTzrtcOy+bIhzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722596596; c=relaxed/simple;
	bh=f7XccJFQ+QycCZFwHexROwL6oGOM5nxC8z9cehuDsO8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LMcdB86hfFZnRqS+/1NotgQtl4MQ0UliADIUwluLww1XYu7AiQ5qHqfFGadtY5N9uyQNGAemVCsvK2oZsr64vAGmEwX6osSt90rzZfpQp7JW83HdmBkNJrprqRKuDjyPnTjSes9B3gJF813Gn5V8Wbk3ooNZOINARCnko5KMh+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=R9KxccLB; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R9KxccLB"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5a156557029so12407613a12.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 04:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722596593; x=1723201393; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f7XccJFQ+QycCZFwHexROwL6oGOM5nxC8z9cehuDsO8=;
        b=R9KxccLB/prVbR+fG+hJV8kJiFKoIDcjyBVTP6biBJx3/DM+zFBbEAluaHyGIEO2hq
         UDbzzY45kSj0QZbQzlIinsPUavEE8S+JmLy3UC1c35+7Fx96n7/zbC7hVIGC4rroiF1V
         PNPTU0dgRG9L8KBBw3qB8WxELmZNf/rFU1beLADe9NLHTh5miVyhgS2RoepSqHDrWQMc
         lf5u+hleJKvCdN+6I7JIfySgYk9Rr0+WCToFDXY+hIJscUavSu0u2ERZlg8HxHe0VDvl
         ReN/Fht1ZNyhKJbiFU117RiIa1isAi44Nf/Iultxi6RpB7OG6mYEF0Bxb9xh3+0vh9zH
         QY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722596593; x=1723201393;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f7XccJFQ+QycCZFwHexROwL6oGOM5nxC8z9cehuDsO8=;
        b=vXTAYKymBI7FUGno52vQ675KQjWdSHSg50Fx3AMuRHyxCU54jT8u7jcij81OQJD3l3
         1zPHSfNRL3IuDRwOfN28UiOYG6Hbd1JuEIZT1D/Pc/fR6kVR359BjDAl5FApVriGuI4n
         oS/tsnldWw7p7gZ3oNQFhaFMp2Zl/2BeEF0wFgsrojYgJnOJV+HySkTegpx8Lklfd8XJ
         gx9nGp1j5k92ZIuAApT5C91wiKs9/ukoe20cMfjrbVcfQsHrBc1qMFbiBZk8L3PiWWyS
         0a2ydriGKl+R2mFqTR4r3n52bsjoR2QXLz6n9dHtnUXcrO6X8n4XDJBKanantnonHkL8
         gqkA==
X-Forwarded-Encrypted: i=1; AJvYcCUcLQE13dcv8D+evW8SDWQFZDvmRTlRDfSkHLpUrSnetim5wfJD3/XBw/4rm1bmTLaDBE/EHWSBfYpfeIkh7tlyDTRV9ckO
X-Gm-Message-State: AOJu0YyendwNYGUrVBxl2+6NAl9kuB/zaomACG8TQBDJMDzAWoFsopOo
	YtfZYb30z+BpMBOxwmr0iEYPUWihTBFUm83ZvLcfsqycbCb+7VYMRB4NCSnd1iM=
X-Google-Smtp-Source: AGHT+IFGQonexgpZjGUwl51oIYY4w2W/jqJ1zQyOCpk3kJFGs8T5j8dynyIwmzMmmRUPMHGi6NWZlQ==
X-Received: by 2002:a17:907:7f24:b0:a7d:a29e:5c41 with SMTP id a640c23a62f3a-a7dc5029a1dmr251865166b.40.1722596592689;
        Fri, 02 Aug 2024 04:03:12 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9e8676fsm84603966b.164.2024.08.02.04.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 04:03:12 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 24FEC5F8A9;
	Fri,  2 Aug 2024 12:03:11 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 83/84] KVM: Drop APIs that manipulate "struct page"
 via pfns
In-Reply-To: <20240726235234.228822-84-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:52:32 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-84-seanjc@google.com>
Date: Fri, 02 Aug 2024 12:03:11 +0100
Message-ID: <87jzgzchlc.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Remove all kvm_{release,set}_pfn_*() APIs not that all users are gone.

now?

Otherwise:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
