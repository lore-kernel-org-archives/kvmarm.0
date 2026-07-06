Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5811B3F58C6
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 21:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783373566; cv=none; b=ozUfS+2IwFLoMQf5JrQqVGxNuI7a88OoqGon6S6h2apQqLxEh9v8LYKD/E4eIpMal6WpGD1ELKdUUstvd0C3yQt8agkaMLJ4dxDmMWq3ubOlEw+Ds1PDDZn0tGtFScr6ZwexaSWKiQD58hDkoG4R5A3AUK0IzFA931bXmtHjhDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783373566; c=relaxed/simple;
	bh=5kGN5o/zEXQARF41Fe2bQKp8S/R/99G74XpkHYXo/DQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=rYErNo/mbBRELZGoQMNXjmlcPLJJGYG0K1IiEiWFTKUBSIy2u+Oe34n5fB7ypQSz/Ox1UD+aUh3o6Qj3R9QQcEev86FrDNprkhicDw1rlRi5TNvewnXZok8lQ/Dgg3R59iDaUV8gtTHzP+aGpX4g1TeT+HxsIaWGW1XRF4fnYa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxQQdsWL; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxQQdsWL"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-486cc29e03bso4252439b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 14:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783373564; x=1783978364; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5kGN5o/zEXQARF41Fe2bQKp8S/R/99G74XpkHYXo/DQ=;
        b=KxQQdsWLhTL8t6WZ2mgGo64OHe4rohpbYtvLNkLcqu7dzwuKOLLusl8OaPTZELV0YN
         O+p6BUF+mfS6F7z79QOwMfXIizTmNdeAENdRQ54PadyTQVWPZvux7HFG8HenRZkt2R7Q
         Hmt3/2qb01fvAfv/htuw1JBXmzUMab3QpzOqxNNddolV5Tvf6Ls1S97sT5HtlCzBeqcA
         RfcXN3gvkJKssAV4CK1NOetA5BfmZlY/7JPPkKKjBjIglB2ENxOl07vXkRd+SPutrQsL
         MY1AORyowAwvhp/9YvDtrCwFk1ZNc0v7ieCxfmaThik3RVdtopNLlzPZrhBfRdrMLFkW
         s3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783373564; x=1783978364;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5kGN5o/zEXQARF41Fe2bQKp8S/R/99G74XpkHYXo/DQ=;
        b=OMXCW4+H1VFmzksaX9xPYuJ513XsJh4f/9j+CUrnGsCra2dQ06nhlBg7CgC5LOip09
         BcD57fcj+wVvxzoMAvSd5TTPMMlEgVGpP4D3ZUChd+Lg075GEowcBdri790oHvVfhR83
         1AJbghQhzNGflMM3lBOoekUcYBA9xSLr2G2AGiBlZcywDcn7LBp5V+I5X6GxDhKVBc9o
         s2WZhrsnnk/7YMuPgc58ttqUYheMbFFnJnpKdtwUnzUboGxpYkQSJ+2FSJRX+oK8sPPb
         4qY6fvwg2lzcWb09BR4P9OlzV6kjh/CRlQzr4hzfjYmFY1buiB3oLWvjCWj2eBcJPojR
         aJbA==
X-Forwarded-Encrypted: i=1; AFNElJ8JJTFqfeTdSJCkXz2+jTKQEyLCLWP//lkHLmCwKzLwaN6wGLK2DTXxMDBSS4IjthtIpbavtBA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzWRjoPlhC38+I0xVjJ0z0QmhOiTjsgGztqwNzADsv3WBDMaRD
	hgRetDt+hb23DMifIleu7rRsPUNkRwZMGLsTLmzxdNuqDH6jfK0iQf19WzIAEpS4ktevfnapuQv
	hhVnFIuIkzLN4/pib/rlfyddyuw==
X-Received: from ilb17-n2.prod.google.com ([2002:a05:6e02:5311:20b0:503:5897:39ce])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4fea:b0:497:da7f:179e with SMTP id 5614622812f47-49fde9fed6amr1716488b6e.38.1783373564250;
 Mon, 06 Jul 2026 14:32:44 -0700 (PDT)
Date: Mon, 06 Jul 2026 21:32:43 +0000
In-Reply-To: <stable-reply-arm64-vhe-66-20260701193800@kernel.org> (message
 from Sasha Levin on Wed,  1 Jul 2026 20:38:35 -0400)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntmrw36byc.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 0/5] Backport ARM64 VHE boot fixes to 6.6.y
From: Colton Lewis <coltonlewis@google.com>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, sashal@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mizhang@google.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Sasha, thanks for reviewing.

Sasha Levin <sashal@kernel.org> writes:

>> This series backports VHE CPU boot fixes to the 6.6.y stable branch.

>> These fixes are already present in the 6.12.y stable branch (and
>> newer), but are missing in 6.6.y. They are required to enable booting
>> L1 guests with nested virtualization enabled (kvm-arm.mode=nested).

> Ugh, yes, the sha1s don't make sense.

> While respinning, please also consider whether upstream 3855a7b91d42
> ("KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()") should
> join the series.

That's a small commit so it shouldn't be any trouble to add it.


> --
> Thanks,
> Sasha
