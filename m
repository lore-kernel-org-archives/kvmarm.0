Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DC7328242
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763138381; cv=none; b=q+9swTzfScHdrOLBz4sAVcVdMVciGEWtqHC2H2eAnG8jOjcsdxWhlMyc8SUQWblNOvMzqubttqmfPpBddARxxXuTQUrP7QApOeidzd9ygg6JeIi/n0ozaXLlho5BQfsYCLnc/c2OtSuBXLMbTxKXJ6dFcPwpMVngA326PTInuW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763138381; c=relaxed/simple;
	bh=0ZCVUMLgfmd6DiDcctwRiIjcoGRN52H8jYjLBR1MlwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WWA3uNaQdBZzqV1c4SFrtKe5udSFziqyaO+j7X8PLOKnprf3wSPPsOTl2OLi8dIv99bYv7s39tk/FCCAyy3kLE21/LRVdIlBB3mD01ZMUQPwrVxeLHnVMvr/1eHc+NlTL7n36ggRT0BI6AYXNKUmDfLVDsx7tubC/2lCv4IXTGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eTL8cv4y; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eTL8cv4y"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2956a694b47so27176835ad.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 08:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763138379; x=1763743179; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vvKuuE+PjYCzOAb47tSaH9inRUN7g6VhaZRxkzeJxLY=;
        b=eTL8cv4yLIK3YcHB91Vt0Hm2zS5bvd9u9sQSvCLihT2GZRib/OO2vfQEaDaOfMPcnL
         WyFIrQ16KvzuQe52htzyLj9Zu9yDAsdxfwoRSmKdGyUFOslS3ICENMLPXOsqZIbMLS1z
         j58Xbw3grj5TtdfJJV27V7FCvjg4shI9Eb7cfvoqLJ07t3857yyM7FoVnsPVlKDEMUhV
         pKCvewEiMMCCnMVDB1Wfnv+FLYhHGe/MoHzkExIVl+fB3TkCAD2E4JGmqvDUMY3mQzwe
         bRjo5AqavBOAPlwY8IyMJ2AJ6NeYPpi++H+f+8AnBVOwIymAAuLY9B4S8uo9mt1wK3Rt
         KeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763138379; x=1763743179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vvKuuE+PjYCzOAb47tSaH9inRUN7g6VhaZRxkzeJxLY=;
        b=rRgRytgBUxZF8immf2WsVJI+dAEvUiAEKMsSbPEqk+cfa5UR6yyFI3qqIff39vp9uZ
         yHZy4KAcOYUREFNlcqTY1oo8F1O/k67BnCpbu5eK+4TjaYi9ytyHTgulHR49azjxYOHR
         ramrofjkeXW9F5qFHozJrFGb5THLznKb50FNlbfnJ/HPZz0lI5f+IN5aieo9sq8urnLC
         YPiHhs70NRkfiKqm7EIbr/zVeeYAYrF/Mt9YpeOjDhq9mzTrR4eyGHxn5ejQdX5s/a9Z
         uDarNQWfKLt8wwbhcThBezw76cSuxaeYsvRkAoX7aLav73c2eyT5uR09gZXEJXoPMatk
         scVA==
X-Forwarded-Encrypted: i=1; AJvYcCWmGaEE3Pdfk7heE05IPRrJnI3KDcyEiWn10jN+efTDM/kZCxWLDcuJe3sfjT3FPL72u0XeWR4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhivE/dAOstek12LCd3o0U7tXu21mJaIFYezOwkkSKBL2o85U4
	J8pHuQpa9p73tuhxsHLNx3KrTsQTN6jEsXVouzCYU5fQ1eOupckuQq/6/i28jdnAEj0NDFxK5rd
	lQcz1Ag==
X-Google-Smtp-Source: AGHT+IHWarhq/WnVBj+1YjmYIbOlKqVYywIAwj5fgd2lO10HbZm9MsXu/DDihp156NA7glJkGLvQ6yfhWGs=
X-Received: from pge4.prod.google.com ([2002:a05:6a02:2d04:b0:bc3:1d96:1f54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b07:b0:295:9627:8cbd
 with SMTP id d9443c01a7336-2986a73b6bamr37888775ad.33.1763138378950; Fri, 14
 Nov 2025 08:39:38 -0800 (PST)
Date: Fri, 14 Nov 2025 08:39:37 -0800
In-Reply-To: <9b2d7e48-a847-4c84-89cc-b8d3962f4498@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250915215432.362444-1-minipli@grsecurity.net> <9b2d7e48-a847-4c84-89cc-b8d3962f4498@grsecurity.net>
Message-ID: <aRdbSYrkSOpUJKAT@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Eric Auger <eric.auger@redhat.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 14, 2025, Mathias Krause wrote:
> +Sean
> 
> Sean, while you're currently in KUT maintainer mode, can you please take
> a look at this? The ARM bits have already been ack'ed by Andrew and
> Paolo, apparently, has little time for KUT as well. But as you currently
> seem to be looking through the pending KUT patches, maybe this one can
> get some attention as well?

Got 'em.  Thanks for the heads up, this wasn't on my radar (I saw that Drew had
responded to v1 and assumed he had taken them).
