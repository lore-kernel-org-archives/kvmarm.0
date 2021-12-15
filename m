Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D877C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 16:02:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9F564B133;
	Wed, 15 Dec 2021 11:02:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X7Z6V37GWvMH; Wed, 15 Dec 2021 11:02:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B36C84B18A;
	Wed, 15 Dec 2021 11:02:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6CA24B133
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:02:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X1s8WWhyZ9If for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 11:02:08 -0500 (EST)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 903394B11C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:02:08 -0500 (EST)
Received: by mail-wm1-f48.google.com with SMTP id b73so1481578wmd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ojSdfd0w7V7R85NomeMNU+dNWNtj40x2sGkRYyr3HT0=;
 b=JYVSeMPRdrQ/41PTdozayyXZLXZSYkzQQG9C0KSLWhh9Br/hQFLt38glrIgdmQN37B
 DAPSJe67qjpRb/4nqsO3ViYn8hRtNfHSnLgjRdUCrcnf70lxqhqwVQIv5WPD6+jadLBu
 NBr1dNs5T7OPU56dnbVYrWz/5qxSbtO/GNlUdNQ9e7aa1zlZ/9/xgzcEfZuYQJyfoDLw
 oX1BIFy0sk+zfpBqP/p+YmUHVmCno9ZzPS98uY+Tz+VEQjSXnQKSJsE1WoD/6ECYDhzh
 ZvvV3ASqutKbPPT/1EJhEqXdrTPubyncO2GjYVwJ3/aYvB7JvBWiJMF9zMxayH2sJtW1
 EGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ojSdfd0w7V7R85NomeMNU+dNWNtj40x2sGkRYyr3HT0=;
 b=Zrup5H0G0CkCvG7TvgbPZxMYdpldGiSPu3HHp9uYhGXMlBKJH0K1qV2Lb843Mhd+lN
 MKBbJsLiGcHGqSIadb/rue04S5YNYGBterDPfbYPa+Orfl7TNMNhMArF+Dz2sTPxAj2/
 frmmOyN5JUB3EIsIrTN8+XS3vZIcglvZq6Q7sk5NGu0Wr8MZZ6Z5buTP2Kvv3V1BJNWp
 P0hHKzNN2s7N7hi0PxND86EjmTVymanEjYSih7k7fg4MpNOoWapcOqXmtQQCEyycLhlS
 TMN02d12u0aP/jsIUb18IEf9yvVdbfXXqP0byW8ABBEbr6Sn2tImAEmXC8az58XsWn/z
 u9ZA==
X-Gm-Message-State: AOAM530Z+eFAaiJ8CObo9tdJmskzf43CbEnvpVVv8DbJ0gbQdfY62evz
 1UxgnBOLqjkANjskTD5rvi1btg==
X-Google-Smtp-Source: ABdhPJxHF+NyYbY/jjawRCuOpa8Ju7jrj/FHpwEjOWpopNN/JwGbTbeM6E/ehn2ANN0Hn9Tx628zTw==
X-Received: by 2002:a1c:ed07:: with SMTP id l7mr501846wmh.12.1639584127282;
 Wed, 15 Dec 2021 08:02:07 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:fc03:4f5b:4e9b:3ec1])
 by smtp.gmail.com with ESMTPSA id y11sm3097558wry.70.2021.12.15.08.02.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Dec 2021 08:02:06 -0800 (PST)
Date: Wed, 15 Dec 2021 16:02:03 +0000
From: Quentin Perret <qperret@google.com>
To: Andrew Walbran <qwandor@google.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Implement kvm_pgtable_hyp_unmap()
 at EL2
Message-ID: <YboRe+ZRnqtCymHV@google.com>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-7-qperret@google.com>
 <CA+_y_2EEP5tYbBTd17c1wuOeZ2jSfhgu0M2b=CpGKjKRgU-=gw@mail.gmail.com>
 <YbCAJZAqUXngvjZ2@google.com>
 <CA+_y_2GJk-F8ju0yXsMc2iwd_yFRQGOY1LW2YV-8bZLANwfCHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+_y_2GJk-F8ju0yXsMc2iwd_yFRQGOY1LW2YV-8bZLANwfCHQ@mail.gmail.com>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hey Andrew,

On Wednesday 08 Dec 2021 at 14:40:54 (+0000), Andrew Walbran wrote:
> Aha, I didn't realise that block mappings, but it makes sense in that
> case. How about adding a note to the function comment here explaining
> that reasoning? Otherwise it sounds like the caller has to handle it
> somehow.

Well in fact the caller does have to handle it if it decided to use
block mappings. We just decided not to use them in pkvm for now for
simplicity, but I guess that might change at some point. The page-table
library is meant to be architecturally compliant (it can create block
mappings or not, ...) but the decision of which mappings to create is
left to the caller and the handling logic belongs there. At least that's
my view of it. So, I actually like the comment the way it is, it
describes clearly what the function does, and what the caller should
expect. I have a bunch of changes for v4 queued locally, so I'll send it
now with that comment left untouched, but please shout if you have an
idea on how to make it better.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
