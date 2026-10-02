Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A6C47CA89
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 10:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935652; cv=pass; b=c7eA2vNCgXCfzFEavcF5/EIq75th/rIb2JHMfobi0wdWU4ggygi7GAel4QNJXExmRZLYWDdIuRB5Zbf7h5JAkwxUuGqir+qfxoYYmWwaIh/DgftQyQZ9iGTG1j292YcAuDb8K9k1cipizI7P7Deb+bwhKa7oy046S4hVrezEdVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935652; c=relaxed/simple;
	bh=FFnxElmYnPjkgCx517QhWsk+SbV5hjMWuaYPOQlgkRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QLirhgU9ussc8zDrDGXpCSc4Pe7TcuZfnPsiRE5TVCo6ufgm2bP6TK6o4iRV5z8wz3GitLoaT6QbmQnMjYKf5uOFgPbHnMp31fyEotNK2XjcuoziwG5xO4hMnS9Cc5iXg8RF0RNiEcDM6XT/FHbuqjq1UH7JZlizMsA3gC+2r1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y6ZqGmkS; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y6ZqGmkS"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so4756e87.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 03:07:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790935649; cv=none;
        d=google.com; s=arc-20260327;
        b=iHiPjGvQFny9QSIv2WKPcvFvEevyyCYG9ZB0FMRZ92o3ZDDtb8s9SsUrVY35QgRuIj
         YIWk/9h8GjuGjsfFvDAuFtHrDL4BiOp8RRYzvWfqJ1E5ZZWSbzNnNUQoYQmqPWgmI7v2
         Sk8jUa50GVtGx0P4Bu6a/qcr+rjE5h7ej6JizULXwGjHn2EprNWbgogFJIfgUM9g0Ldn
         Uj6pX3oJhOIrKZkPHX/gAfHUmwiu/Z2rHJZSAUaqHlnrLqXfJ+4FGflY0Btm2lFM9Fso
         hUdw0SGGGvYjTaMUws5gsOECkCqxx4vYNQLAwHZS0NiDLyr+q2ZALQekCjVQ21CXfKYZ
         MaLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=W2aHjvSPxe+vAP9qLitaZl/l2SuTqD1rpV9O3EUjP1g=;
        fh=W6m//zf7NFWt7Bz+vpiDgw5wXWDvIx+zJ36ycwNNwgk=;
        b=Eea8AwJRdpH6Go1hFm367e96OqR/+PQawcX+g+9/lgh/FekUHWbVj2r0+PKoTwMXaS
         xzBzT2I+e3N3S0kvgF1ZjCimqsMOQWz/Hqpv1CHsgll0Pr8xP2xXErcR80Bxe4NEpGix
         Z7cxjKghWyGJ/zqOoA8HV0NKvIQ0zk5TYhppi9aennXUlBjeEIwpSjAir/7fKQDMGMcj
         IMc756OwMUnolW6iBWO7SIeGbsCJbZoa2w5a4PE+cVUirKwxmHoxvcD6aWNSV8DQ2te+
         FMvTzDFKMIh+jh2T5aNQLZ3ol77e4Xs0iTHTBvKzFtoZJB5mo5w9LI9jwfsPI14hRjvz
         rX9g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790935649; x=1791540449; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W2aHjvSPxe+vAP9qLitaZl/l2SuTqD1rpV9O3EUjP1g=;
        b=Y6ZqGmkSap3dNZe2VT4qYXYGBtB07/0NVZ6YtbUKON7DvXc6ZxmeJItyxtViej8kAi
         jM7iKckBC0+OZz67QQK4iMmzjURvI4L4tybj2zsqbcu0WLa1oU3uMrh+3WMGvlxdqZqY
         xg3BXoUsrgQInVw/5lhcKYMlTXCVuDXJIYZmKuIiB5JwMaSCrqyNJEOK9Xe/2As7REQn
         BzLI1T6cXrgVrInReKrdkCAKY1pTdGFaXQB/RgBis8COh9pWABzB421ONsA+4lxA4Jkg
         1uK19J5Qd4+U2fc2T3u741JlZ1tVAg9B362dhPAU+c6xByFGl7u5WFcnQc6CDcecaAiv
         XiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790935649; x=1791540449;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=W2aHjvSPxe+vAP9qLitaZl/l2SuTqD1rpV9O3EUjP1g=;
        b=e/mNr7Poj0NdI9JhGFEv12Lfy8+Rpn+QgezlE6U8Ioi9R5SYyRZl94JTW78tVGNPI4
         1QrnmwB3cbJUluOdEkO4HL1NIEP9vPBVDkxYTzI6n7trAWkd0kqCUjnztZ3kVmcsbmhf
         LcW90oHHSuS9Mw2Lvj4laDuH4c8aqG9ytMMC9ufMV5TSA5XSsNu4vCERsBEz/IkdoODf
         9N8uk/5HXp11OJYU9Ifz3c/FUCyF7ScIBGTVG56cFlFbH+MTK/OPnYvi5ulh7zOdoBwu
         6YyBBkUTreCvGE4e+75ixpll8+oI1xCu3+ST0AYQdmS4NxVl3Kv8GwQawSCkcidRNY5u
         hgwA==
X-Forwarded-Encrypted: i=1; AKwUvBxEc6KlEL8CQr7SHe/4fLrn118FBOmckdc7A3fXZ7gv1iiUWST0tIPw9/CEeBllO4rZGcVKcf4=@lists.linux.dev
X-Gm-Message-State: AFq9FYKu3ixEv/xFv+6ALE7l/b5nB0Ncc//rYr7373B8xoZuJQ3HqqZE
	egihqIiuPx2lubjMyYbuCsKZmt2Xd3bl6b/I5DXYRNM1wKcOXIFAGTYLNDpWuWtIvUdlTBCQ7DJ
	4WbOY0SCso5mdxA8C8Cu7PoEG+f1o2sbCZ99OVbwS
X-Gm-Gg: AYBFou2QGb8uxcz1aBv62tWvnHlJGK17j0J7mW7xfFC8Hxtp3qP61kZ4Zd5UFWVx28V
	wCY9T3RidyIuMQK1Tn+OtdkjmVpzOJMDN8EOLjJOaOd0AayNNPmWYaRTQJcwb8uEjtOoWzzo3Ov
	boJov5vDYsq7JFBF9CewxrOWW+euDpfBwA+Pgayddy900LWliLdxtv+s29rB+pBZDIgGhmq/ia8
	ZWFXVqBowqKY0LVtPqI9+VNL9bYmGUhlfgmNaglmtJuOk6c8ZjcnzAjSTHR5Mgj/HgzODeKXLtQ
	mnzhe5fiKVWoB9jqTUR6chkOS2VYXKd9k7Qkx8a8yZZGGZR+D2USjxprru145CkZHanwmS2vLmR
	2Jxp4GgAxdjFHiQ==
X-Received: by 2002:a05:6512:3b26:b0:5b8:d04b:a1be with SMTP id
 2adb3069b0e04-5bb7c91a8a0mr135912e87.2.1790935648531; Fri, 02 Oct 2026
 03:07:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001210703.1597150-1-suzuki.poulose@arm.com> <20261001210703.1597150-6-suzuki.poulose@arm.com>
In-Reply-To: <20261001210703.1597150-6-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 Oct 2026 11:06:52 +0100
X-Gm-Features: AclHuK9UDCM_CxoGcsAnKo4MTwuWCAngd_IrvUFvtXNGuqDBjBBZg_tfUnO_TY0
Message-ID: <CA+EHjTxtatPyGcyvEyR129cqUiAYcO_cxRVtwZO0ckZsOnD7TA@mail.gmail.com>
Subject: Re: [PATCH v21 05/23] KVM: arm64: Track the type of VM in kvm_arch
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

Hi Suzuki,

On Thu, 01 Oct 2026 22:06:45 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
[...]
> +#define vcpu_is_protected(vcpu)                                                \
[...]
> +                        if (is_nvhe_hyp_code() &&                        \
> +                            !is_protected_kvm_enabled())                 \
> +                                __kvm = kern_hyp_va(__kvm);                 \

On a non-pKVM nVHE host, the hyp callers of this in switch.c and
timer-sr.c now translate vcpu->kvm and load vm_flavor on every guest
entry and exit, where the is_protected_kvm_enabled() check used to
short-circuit. Could they use vcpu_is_protected_pkvm(), and drop the
kern_hyp_va() here?

With that:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
