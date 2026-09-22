Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4260D549374
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 21:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790111446; cv=none; b=OYqaUnJQYae0JaA/+l2fT+gxdKidjygH0Bz+71okINgcX52KQWJzeycEq1HlY9/tEixeF89fA4a7rYP8EuvMHjc/cdHljqdYZ9kF49LMNnHHXcrIeOvhG7fx3myLEyqdz4qJc4wBqPYGwI5SzEeHAzq/6c69Ck5JVNcjsN6t78U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790111446; c=relaxed/simple;
	bh=ZLzoHhwTaHnhjMBvx7XPbj3yAjurmamgiA97xqI13vA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HTzow4XGLtVzaCWvRSeqpSZ/jBzImLTc09AZHY42QviX9adtjzJlnGYu/4667IER91/Iprt5eyxpEKzP+BBzeulGMROndB5Ao/HzarD13RJhJLfNd0gUN3N/0E+wGr4CIknpo1VYbJHjSANCtIo6gDnJgCsH7r0RdV/gJsHNROI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JvyVaJaj; arc=none smtp.client-ip=91.218.175.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JvyVaJaj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZLzoHhwTaHnhjMBvx7XPbj3yAjurmamgiA97xqI13vA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790111430; v=1; x=1790716230;
 b=JvyVaJajPn6oCPqwzZo0n1qYB2+2bfMifzQV2gk36kUt1/Jm6CaDQnEum2vHTxtUNoKbRg23
 2M28/6rOQzgXpuE30O480Bz9QmOk6oBsG+Nox6DQta4ONpt7JJLqcV9oWVk6NUu87ctvRggAVCc
 S/yjnAhWstFYltSrc00hzPsE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b08f0698150692e9;
	Tue, 22 Sep 2026 21:10:18 +0000
X-Mizu-Trace-ID: b08f0698150692e9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b8c42da963so1011e87.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 14:10:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx1C82BBtcdIt51HNDFFjZKqEaXA4PsSOaGjeNjaVQFF2AYAzXs1UPsZUIZk+ltQ7By9eVbTI0=@lists.linux.dev
X-Gm-Message-State: AFuF++k5ZUjuVsR7VIYR43F0OPwUFoS313a8wN0A7gPfLO4A1m1IBjTJ
	w54TANKD2UgFcptkzBPtGbxnU3VWaMcRFIgdXYEO0tiHYd2dsutwllou8WTrGDd9RiFgdJ2sq9f
	QRWFA38PTJSHMHZsRsgkHkhJRL4An8tWnF+x9r34b
X-Received: by 2002:a05:6512:a84:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b8d87fcb57mr47663e87.4.1790111413647; Tue, 22 Sep 2026
 14:10:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922181430.3532371-1-fuad.tabba@linux.dev> <arLbbtuRuOrxlh1Y@kernel.org>
In-Reply-To: <arLbbtuRuOrxlh1Y@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 22 Sep 2026 22:09:37 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx8JsXfrjKUbhhrfSmFPrWxyYaTbKqMeYAJPt-vqGfLvA@mail.gmail.com>
X-Gm-Features: AclHuK98e37nffnaw1F9q5cHTfaeClpU9qBwO_qQHRPF451CnbaMSkO3wxXcRx0
Message-ID: <CA+EHjTx8JsXfrjKUbhhrfSmFPrWxyYaTbKqMeYAJPt-vqGfLvA@mail.gmail.com>
Subject: Re: [PATCH v1] arm64/boot: Disable trapping of PMZR_EL0 writes to EL2
To: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Rob Herring <robh@kernel.org>, 
	James Clark <james.clark@linaro.org>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 22 Sep 2026 20:47:58 +0100, Oliver Upton <oupton@kernel.org> wrote:
[...]
> We can trim 3 instructions from this by using the read-trap bits as the
> starting point for the write-trap bits, like below. It also makes clear
> the point that most of our trap bits are symmetrical for read and write.

I did consider that, and went the other way for two reasons.

The read side has three bits with no write-side counterpart
(nPMSSDATA, nSPMDEVAFF_EL1, nSPMID), so copying x0 into x2 writes ones
into three RES0 bits of HDFGWTR2_EL2. Harmless today, but it's this
bug in reverse: the first revision that defines one of those positions
in the write register turns the copy into a silent behaviour change.
Building each mask from its own register's names can't do that.

It also matches __init_el2_fgt, which already keeps x0 and x2 apart
for HDFGRTR_EL2 and HDFGWTR_EL2. And even in that form the copy would
have to sit just before the msr_s, after the SPE block, or
nPMSDSFR_EL1 only lands in x0.

Cheers,
/fuad
