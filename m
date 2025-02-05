Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ADA13D897
	for <kvmarm@lists.linux.dev>; Wed,  5 Feb 2025 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738781357; cv=none; b=fhS/EfB3341MiBoIG8GpyYlyyfv5y5HZjP1jXqtqpsK41e7tPfcKRGhqNt+RUqksr2B18FnQWH598L5FSnWYuQxX5dRPFp3GOMgT6bOLC8bmUKV1XUvLkY4nGZJAP8KRqkFaiovk7aIb/pY1zNA6IADJkMr+giwj60I6JXeWLpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738781357; c=relaxed/simple;
	bh=RFLD5Y419LMLKxBPptSqSiuNprPZyJrTzacReh60S5o=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=iMUV5B1vv6IoJYCKIVrBFZYhXAQe8T5IFjOAHJB71YRq2y8Trf+/iQ4SolOHCqexJBJhJb+v0c5AMHA8MnfbkTA5OrOX6/nJOYNBZfT78EVe2JTxCPXzGdufQ9hWVfHpZnvr0R7tlDK2Zz+s7IAyw6aDdb+jbXQgrG3PtLcVHOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I7tIaA2k; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I7tIaA2k"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-71e197d0cdfso112133a34.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Feb 2025 10:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738781355; x=1739386155; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RFLD5Y419LMLKxBPptSqSiuNprPZyJrTzacReh60S5o=;
        b=I7tIaA2kZ9mTA5Not9PQCR7Z+7hmlZ8VAKeIxGV1dovGZerHm9j3rEijYGtx4S1zDo
         qnkmreEv+Q+VsHNDAslu7WyH+knjsQCoX8iLTCvy4VBkSyttiFp4fPBKtzhYWvdcQ+a3
         V4snf4P0i8X9QUVECevsSHD4zIzf7iA78QRIw9rx5sZMuxFF0ArF5eLpLMLAmoSwD0FY
         bCcWlcDJbIOpO/ChSRG5pR/rPB/xFpoR094QkmYc5D2oKTksEujrZ0aJbQTLmtzE4Zi6
         cI6PHsphTOGBHl6FykNQ8WHEODtpgKSeUbJxG+n5ohpmbdKVApP8NFA1OGKcXmi5GaM8
         hgdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738781355; x=1739386155;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFLD5Y419LMLKxBPptSqSiuNprPZyJrTzacReh60S5o=;
        b=aOiBc+pGJ4FgU+8zSuxV0DWJL/N5RMH6DlNUIols9G53v7UP6vyjQrJOTlscs6Yhls
         CeAAlDFZxArY0EQfYH3JBiIogYvbgc7enNV7jYE8eWv6aOhxzayB2vCGa0ob/7+/WuMU
         W/8u3Dj1QYPg0+Yuv9oWzMqnKU63rGdvED9o/gIo5HIjH+uiHGcwhekUFkb7puoMgvtP
         v2n8E7IAb9GWuyNc2ZOVV17e8cCjciOZWoOiZ/VGzbs2bRotuNUBU2PnHI+p71C7Y1Xz
         ZR+tLIx3Xuc+9pFEMaF3jX9jSD+vDDGAlfmJ1vjlXFhb40izYk2wjCgPmNToUlUCuTu/
         Fr8w==
X-Forwarded-Encrypted: i=1; AJvYcCUS3gQx85fMWYSWIZDcWiHwiwsABfAwIRPpQoqrseCEqYtn+N6RgHdHQB9vavJv5bXT1r6pmL8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwAXZYO9g3YQp4SHPFNj6T3ef+oC3WlMZ3W9tVMpddNXCVCNOa
	o7jvhp6OYm5WdBXFOjDiynjb+6P7LSxgjiQXrM/gZD8XJHxO+qa192s312FgEFBOUxuBPy/Piho
	BEldCohfK4/tWXB1rUeN1bA==
X-Google-Smtp-Source: AGHT+IG1848Nyq0Ep5YZHUoXqdxSYPedyBRtjzatXIPDIYwQRd5LUrtw/B5zE5Ng8GmU9F7dXNmOSuoU4vizvGXdRQ==
X-Received: from otbcs10.prod.google.com ([2002:a05:6830:678a:b0:721:b316:918])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:71aa:b0:71d:f6d3:9fd2 with SMTP id 46e09a7af769-726a428cc52mr2331443a34.24.1738781355567;
 Wed, 05 Feb 2025 10:49:15 -0800 (PST)
Date: Wed, 05 Feb 2025 18:49:14 +0000
In-Reply-To: <Z6KoUBdmjVRuqPnU@linux.dev> (message from Oliver Upton on Tue, 4
 Feb 2025 23:52:48 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntseos1b2t.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 1/2] perf: arm_pmuv3: Remove cyclical dependency with kvm_host.h
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Tue, Feb 04, 2025 at 07:57:07PM +0000, Colton Lewis wrote:
>> asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
>> which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
>> causes confusing compilation problems when trying to use anything in
>> the chain.

>> Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
>> because asm/kvm_host.h is huge and we only need a few functions from
>> it. Move the required declarations to asm/arm_pmuv3.h.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> Please do not move KVM namespaced functions into non-KVM headers. Having
> a separate header for KVM<->PMUv3 driver interfaces is probably the
> right thing to do, especially since you're going to be adding more with
> partitioned PMU support.

That seems like a good idea to me.
