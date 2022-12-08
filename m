Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBB8C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 17:58:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DF3F4B9CE;
	Thu,  8 Dec 2022 12:58:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ventanamicro.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j-RJbcOfWtdW; Thu,  8 Dec 2022 12:58:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2F124B9D1;
	Thu,  8 Dec 2022 12:58:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D933B4B9F7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 11:23:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 93jN4C87RSGr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 11:23:23 -0500 (EST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A74EB4B9D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 11:23:23 -0500 (EST)
Received: by mail-ej1-f43.google.com with SMTP id kw15so5236490ejc.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 08:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ventanamicro.com; s=google;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=3ffOMrqHbGPKnX9DON08suhw00B/x5l9qlgIhBCvn1s=;
 b=GcVbR78qgq1zGKeFap4dpyJP2ETn3kww5rg3v8dPl3tCWN0G6qxnGcbwgcX5MCo3OM
 fKWfEFTBvO7N8XCZBPsxpIZJu/I7SUe3aPGwiRpN/CQgiksUDLrb6z4cKnWd08AfEpdZ
 r94BbeUn5ovd//wzHhKXPJAWTKlrbHK2MlOIz3fbM4mGNb97gj9dHvVIeeiBbVWMUG83
 kIoNpiUMsufVsm/m95AH/BSknL/IIYi4+Au5NXHpzpAF6U9MwGhYl2DJgI8UrQgHnbO0
 7dRNIeeoHyKJg18727lHNV+cCrVrJsiUn1rn7oMXL7Wu9l4f3Ev75gNhks+qShMbBZI8
 WEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=3ffOMrqHbGPKnX9DON08suhw00B/x5l9qlgIhBCvn1s=;
 b=mJ2a1LyIcmESuo9Q0l9T/Kmz1rxzDN4KTzAqmU7BHcpHEE1WbZADJqmuq7iyTItErb
 ZEP8+ub6B9k7/Ihy8hX3/fM8eOqMQQDWOdN+9CslXnNZ8OAc07TjMNgnoPCFtY1AjL2B
 aWtTHorWuxPNPXEpEt02vMjgW4+CpxaSY62DutEKpBiSlj1B+BP6yJBAKoaDmsw8SeGs
 h6lPK5FNJev62MaOY9ktBq5BuMyx02NQV+5YraBy5BTWcJk3cwJZyCE0SOpPwGe4ZUh9
 u89f7zENi3u54BwdtUcahBu1FBaw629bCDU0SB/fiP90n+qhbEFbYhqZunQ1sikrev5a
 6yIw==
X-Gm-Message-State: ANoB5pnpZgwX3suh0GpGcsexZR+rVAlQFWJBvloMCOPRdS17uvIdBwds
 gja060TY1a0z7Ju2ExnTY39Ckg==
X-Google-Smtp-Source: AA0mqf7cWc12/11dRI8UuaKffduEO9pgwBnCtENeaj4X4vsk2ZRqNQGH/MayWHmkzyTTju2hui+ZmA==
X-Received: by 2002:a17:907:a426:b0:78d:f456:1ec6 with SMTP id
 sg38-20020a170907a42600b0078df4561ec6mr3278655ejc.23.1670516602675; 
 Thu, 08 Dec 2022 08:23:22 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-748-2a9a-a2a6-1362.ip6.tmcz.cz.
 [2001:1ae9:1c2:4c00:748:2a9a:a2a6:1362])
 by smtp.gmail.com with ESMTPSA id
 i9-20020a170906698900b007bff9fb211fsm9884789ejr.57.2022.12.08.08.23.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Dec 2022 08:23:22 -0800 (PST)
Date: Thu, 8 Dec 2022 17:23:21 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 3/4] KVM: arm64: selftests: Align VA space allocator with
 TTBR0
Message-ID: <20221208162321.d745p2lsedxdf7v6@kamzik>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-4-oliver.upton@linux.dev>
 <Y5EtP5z6rxSK1VUe@google.com> <Y5EvVtAoDSHvIKie@google.com>
 <Y5E5UixcJQ4+tNYg@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5E5UixcJQ4+tNYg@google.com>
X-Mailman-Approved-At: Thu, 08 Dec 2022 12:58:22 -0500
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Dec 08, 2022 at 01:09:38AM +0000, Sean Christopherson wrote:
...
> Actually, before we do anything, we should get confirmation from the s390 and
> RISC-V folks on whether they have a canonical hole like x86, i.e. maybe x86 is
> the oddball.

riscv splits like x86.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
