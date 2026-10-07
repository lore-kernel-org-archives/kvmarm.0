Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B945E4AB1B4
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380756; cv=pass; b=AinKyi/8XpjBw/pJGiOlmvckwrxi7uhbbRSuDxnMMumhmxCY0CNqwpaJ4CCIrc4kpEs5CBAQ/xOOqWjts3ltz7nhrQ4N60HSSaam90rknq7X8/6qNGzCnsElHmQF9cZk7OvgX2wAjX2Z/TS33CLmzuX9RNr1NinACXUVm2SsBWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380756; c=relaxed/simple;
	bh=7R3ym81WdAEtexE6jWnwa4vea2N/jeqsSvQGrEvEZOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gtFIArblgbG7FIx5StmU3q3t7Q6uayvJ/wM05X/kQd0UbOjR+KVUqiaA6MMOUIl7H4aEfVxVCOeSgM/6ZjT5eq/17jTKiI6OTpPRXoulj8fX1NDtKQHFdwXCjsueWl72VpcKYOd3Djhf0+h4xtFIPqas7NiSNQ9z29PxZOvISwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CZuRhzjj; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CZuRhzjj"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so8738e87.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 06:45:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791380746; cv=none;
        d=google.com; s=arc-20260327;
        b=m3qPznUuB1GSI6L+8KhoTJR+nJ+Lfb7vvgD+fkpEAVk8vhplwNXmCnFlhrC1XISbPE
         NH+KlfX145WbIyH4kgjgS4PAvuBBr6bPof3TPFoj7cmcDexObHxu09ZfIOiCB0OCC+D0
         MjY5352VaRyg21EQq+vkwFHHU0EdsbnocDTyVHEoIpArhJHgTACZ0pEm7on26hyeb2TT
         Zm0XsUHbH53/MH0WgYtcsxCpl6krj9tDJJQ1IGws1UXkpNPfRR40rYpO0uFS3SV0XodP
         vvT872z2NSV4rFydXj518P4cns1x6B16E6h4z1CsBLTKIXh8qye2z1tYiCvg1NtG+GIL
         VwYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7R3ym81WdAEtexE6jWnwa4vea2N/jeqsSvQGrEvEZOo=;
        fh=NuEzMNxe/ChyJqRPygJsYIZPB0fZ4oJ8f4kcJ78/Vcc=;
        b=joAKMUqP4yU7ankb5NEA2JZnA6M4JT4/FvyNcaclVsrdWYu+Mf5bCEbpXCOpRarInM
         rXabJsxTkw2+bsm4t8gG3AAxg/Ud5o6SanZ2rCScxCFO+2zSlAmKJdO9pVxZocP8BgP+
         JbMeDUISQ0pP0CtIQ47hagFPSkOXjN8lc/UYzRebvrFT/urNk2+k8ReHsaGe1WVqoAJS
         wyZhYs0DxHoeUl3GxPmwr5r/sSJE1OZd3ngDBsgWESziCmKnIPADfWRTCH+Kpcg7pJnj
         SA00nRNkeKpEyDBUxEQRBPXU+4z2BzYAwNPkFnMMfXVZA6VpLLdkJAyL89H82gasB5dl
         /9wg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791380746; x=1791985546; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7R3ym81WdAEtexE6jWnwa4vea2N/jeqsSvQGrEvEZOo=;
        b=CZuRhzjjpY2xIreezXDHBSy+spQKQahBgMhyb4WNIQ9lGuk+DobYluvGKy1OCZnlkJ
         IYk931P2s8H5uHq9ljCulvz3BGZ13Y3k75DpCXeH9lchbwwECPftdKDNnWG0ThiE/vpP
         lVT1zBJc5ZWZ2NWZFqwAmXuAQuO6WWVof/iB7E9OdQb678xFfLKPg1EkWDGRiniLe2qt
         sBDqKEJUjgaLsgFCywXOrPIYuhcsBBZk+aB3dEuFl2EYig6kyM9kI9ZdUVAb5goOPPn5
         ZUY05YfI1d3eYOQ7nrRviKOrogr3TPoExYHaFOencc5gfGy4OWuw/evUToSMOjzNVczr
         lOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791380746; x=1791985546;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7R3ym81WdAEtexE6jWnwa4vea2N/jeqsSvQGrEvEZOo=;
        b=GtaaW3F8CPvl0R+9n5JNszj+ARBlpHtdhAwVVSVY2IglG85PNz4FMPnHeU1CvoXA4h
         SP+1Mp3NxU00mP1phWgNAuJqXhvZ9K6PXfeCkGwxTS6er6mdYW1wFpNC4sB8xMqM9ofz
         hbClWG7qGoRHFP4Up4Bbk8Q0yeGNU35LC4T5ZrjZLNuFT3b1MXkmJdl6jRIvHgRkvGKY
         Ra84qJZSUuqXgK/9/6DxLCoYv0MqdvPVYmNjw1qShOif3zlbEmtqSWro2omkPPSSQTqr
         sc58gcXs6g7+lPEu37atKApVlIW1ohnesCQk44q+8Obljr9df/xSlgkBjlSKTeJp/rQt
         n2dA==
X-Forwarded-Encrypted: i=1; AKwUvBy7OreqGWobqP/sUSknecJJDJZR1B61tV6ZrdPuiP7jUVRgiXFevrt22+P91Bd0t7e2KFELaKM=@lists.linux.dev
X-Gm-Message-State: AFq9FYJBO3Dwbv67RywkN9thwD1RN6VrBA3uOA9QqlNPGgMz6ny6B9TX
	R59jiB897bzp35OxFv2Odor7yS01wPaOc+LRnUO+ne+W85ipZBfHo1MfgvEbLRHZ5VuoxeMikFq
	fVxPSYaxTSRP5rB6v3e23Q66a8460bD8onWgmj5au
X-Gm-Gg: AYBFou3z4u49Ibks1ALx1rb6rkrtFq7A8z9DVa62+9ZsMdjMQQkVDayAY2ecCT5p4g0
	Tf9HqhFTGY9LAmjXFpegnfwzA4l7oANIfScL966T0IWIvZZLBgoIcRFu+sE/BG8O/bzre1BiXVT
	YeYAoDdeN5TIjDJ0CDoralR2aGsQj60DKoONUR3l4itTagpXtjlAa5JWqtdZaBgAJ3cbIiuu3vy
	IAOsFwW3g9dm+gXryNZmaV3Cqw/Z2lkYSpXYTod7SfZ0MoBKYa890+AdyrZvWXN8nVXy6aethdI
	myERe5tBMAplNDL5kxolbZKldSdJcAninnLTBJag0s3O0n/s4gC+ENS5
X-Received: by 2002:a05:6512:33d3:b0:5bb:ff6f:b4bd with SMTP id
 2adb3069b0e04-5bcca66e395mr320554e87.14.1791380744549; Wed, 07 Oct 2026
 06:45:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-13-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-13-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Oct 2026 15:45:07 +0200
X-Gm-Features: AclHuK9NBZeYXTKdDsAbHTEgR4p43Lr3P06clWDgtHoGILzFBEkx0SOT-Ggr9gA
Message-ID: <CA+EHjTxuAh1zegQGA0-dNAjDBnXUc036WhoGxoUvVmMW1BxdXg@mail.gmail.com>
Subject: Re: [PATCH v23 12/14] KVM: arm64: Abstract out memory abort handling
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
> Move the memory abort handling under VM specific s2 operation.
>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
