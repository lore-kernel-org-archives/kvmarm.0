Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7944A0F1B
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791373155; cv=pass; b=U/5fDtkVIuUDbjhIA/aSaND4xiw0kWv3MluptE31doeK0bZ079EXiK1O0ipRAZBIuyDT3s49fXq7v1Fx+FIP4MBe0trWmGH/V+jrx6KRQ4qfCQCiGBNmTSdmzrKgDgZDibN6TztN9QI8d5+NaFLmF98qTpOlAdG4H4svPgF0zxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791373155; c=relaxed/simple;
	bh=x3BovMqKPyOzodOG6cYU5vpG492YG/WZZeesFshGEqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KIs+E+9bnv+IwM2ZAhiq8V0k8ozlFbuQp1SjQDDF3bU+EIj9GTlME7p0+YaleHedAZQj/+UQ51dGE6II6tPPXv1qCUlzwAZlz7JKGpUeHn3da3z22t1vK8WqzlLQSYwzmdfoVY6Yhfbtvgc5m0rISqLpziMotUdGWcKQDOxR4dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=knkIgQLx; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="knkIgQLx"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so5842e87.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 04:38:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791373124; cv=none;
        d=google.com; s=arc-20260327;
        b=oqyFLOQS5zbIpm3U1KUhOegw9uI17WZHqmPmOGl0CnAmwYqLbp0oThUYG/wU3hPvdG
         gl+jC6bK94+Y5MtGYo0OUW4C+lBxElaVX+SJ7/zyLxpiJOSxP54llZHF/SZ1BXoHdTiP
         GIv3ptjnOTvk3ONdxA7w6YY+YeHaiRxDd/AEJSEgZ5H1biiBgKbb5d6WamRCz6ZGyZxf
         EBsujsugRZxwhMk58HbLK8GxzRPXCS0PFA+NUnp6vV5JucwUZoYvpu4uJETRu0EmmX7K
         G+yp41Ix853GqiJ8x1ooOzJHgSB8ODLYKVCCszIFWWD3PxecKRsEmu4OpcvEj2FsNj5x
         eMMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=x3BovMqKPyOzodOG6cYU5vpG492YG/WZZeesFshGEqQ=;
        fh=cyD86Sozc2nF/9rgYfxyIo97IC4AOu4itnzKNUoMMRk=;
        b=jHmm2qk7R8f2Z8TW7zyHsQ0DhqUpyx3HyNyixpMT2yRz3gUYRFO+cyrBri1ulO0yvY
         yX2Z0aLOm9RLHnoqk/YBCVmX19c4ZZ4+6Y93X7UqRbT7HQj2+3aR++WQoNLNPSaQ6l5e
         nypuWoSBpqG//+NchOdrxGg4EkjF8hPS1Zu0QiLzlugWYXxEjAjl7D2jIGBNirU8juEu
         mbOZ8/ZZOGp4QFm9Aezkk6QaqHxPmVT1CLKqo92zFJpK6f+OPwZeNYREj8bljlKFSVAm
         b4+tWO/O9ySOXnYuWete3JYWvCDLiuVGtSwFLrBFflMLPzWa3GS/0ne6Cv/dVu+und7q
         Lr8w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791373124; x=1791977924; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x3BovMqKPyOzodOG6cYU5vpG492YG/WZZeesFshGEqQ=;
        b=knkIgQLxeccbbViv57odLKVN1eWe5J8YNkNPbHF+ZatWrn5jZGOK+Rm+ZyCBZAWb3e
         C76NoyEhunayFl0iDldxYUT2B2wmghB6W5SiH3Gci0WxlUeZwpnqM7vrBh276msVuN2p
         KLogrQ5Qr6cc0VZumi8LPV2hIlcXxsFZBMfe1wtchwJSrgcJLNe3cI3fGX40Yrj2NBqe
         qZgITNwM06EUcRBAeDyzVBkpsvNtyGAiTUttnfQ/72dJtE2qIUFOl47lGc+nglM5AoBk
         msLR12sjqLl0e/hM2NeghVDhzQWdK+UQfenu+d9Iyfeu5jZSqWwFIaAb2Evby0bBh2sA
         ylMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791373124; x=1791977924;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=x3BovMqKPyOzodOG6cYU5vpG492YG/WZZeesFshGEqQ=;
        b=homvZBBWMtIiewFc5rldxgegqyBPoQd34pDbD5ZPsdvMz1ZR8awXlwcbJmS2y5R1sF
         sCtDCMyXj6WMF7QDaafOseNtRBhwcZnhUofK2xI5e2HqZRaHhd6WudUceX6fgKe+/MxM
         lTvuhDINJI/hptihW1V8V4JDM/OjL+VP0Kqtei+p7uUpxLeSNZMdPGQrH/M1HbL4adVt
         /RN0uQknGj38FVMHe6xx3CQEu+jtth7MDI13aFbIf8OhKjBMsweJngySp2MrVvVLt0d4
         Y1a/mQxJSz5c5o3/onG41Xz0BY1nA/csACaTuoogQWA356qewC5vLlXHCnY7/jd7xTFn
         tdeQ==
X-Forwarded-Encrypted: i=1; AKwUvBxUEzYgfAO0eSBVv3cA0TCIQTtG6H5wHsxpaOB1GDl4gMh+xOyMt015GVXpBH/UdZbdP8q/p/8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJCgT1vGrTkBtuXJ3iIijFuw4jxGhG79Fsi6BrOSxqzDbtOgxcO
	2RgjhL7k5/P73uQsiSQbUENuzDrJijFy1nl3eNGmTPL808a4nKCl5HU18yRfj6RrFd/CqcAAbnR
	p+6dvOn+RiVcYqRgZkxnE5k4ON99g7JVJiJx2NFXs
X-Gm-Gg: AYBFou2qWtX1+lA86RGaTayhvttRK6mCgSXImJLNH1vh0bxPMsfx0k1p6AxR2CKtwue
	soJqBS5Wr+9PxX9MDaltwCda5F+Jst732ZlbSbmn4byNKWj/qZ7AB9DF/DrKfFO1eBaV+0p+9f+
	T8OJyh4oNYulDNjXc+/WvinEULRZRtXdJCZ5arO06JWvAQwcIAvZgxa1T4UD+xoukzGJgxoKOf1
	ySgcIVbwMeZFtC+IsBEHfz9jL2CdBk991H0Ib83jtCBNAzd57m7GbPDzeWIz33+iPBlU2GAhm8d
	NuEt1s2yzWaA48DWGQeOd/IE/EFm/ai6QaWlA1EUebh+FTuqF0y7H4WZb0XQgl95
X-Received: by 2002:a05:6512:3f0d:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5bcca857470mr322236e87.8.1791373123590; Wed, 07 Oct 2026
 04:38:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-11-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-11-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Oct 2026 13:38:06 +0200
X-Gm-Features: AclHuK-THf1WIqt3xPRpWJs1Q81-pzVnFszT4A1vRUwtheoFlxrVY7-HpfrRH5U
Message-ID: <CA+EHjTx=CoD5vUN7X6VcuoLeoqXeF_h_JVuhiwaHLBqNraZg8A@mail.gmail.com>
Subject: Re: [PATCH v23 10/14] KVM: arm64: Add VM specific callback for S2 MMU operations
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 09:36, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> Add VM type specific S2 MMU operation backends which can be initialized per
> VM flavor, to keep the handling cleaner.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
