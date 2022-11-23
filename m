Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B567E
	for <kvmarm@lists.linux.dev>; Wed, 23 Nov 2022 06:08:09 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id y10so14562933plp.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Nov 2022 22:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h5tlKNi35V94k0QmV2ysH94Zb5ALfgaBlCa6CRxYIVw=;
        b=eEdddm6ebarYt7g7uJhWOnpgtypJcRMCmOrwuMaNVAA0C5aBaCucbUGx0fVJIOPlSW
         hNU/iCZT3w1eHA9yNvRVrKP4s/WGB5nWkZ5SNaTLoDMrZdetIXV7DUlzXgQ0ZI6O6D+6
         turNtaZkl1rWGQ25PWMZCrZdZetW0KQ5nSknO98LM/koczRsx+sr997Z6Y/nWEVSjfkg
         qVEcHzGhPUx8KY4y+poF1Ed4OUzls/fCfaCQ+ku5rLVm7nWR2Fvu/iFVPShBI//SIcTM
         EYWYxB+VjSWM0PzjWaZYoES2vXUzhfLJe96SE6tNaWrzXSI35zv+R9NxKDwCNWfzNNlH
         YRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h5tlKNi35V94k0QmV2ysH94Zb5ALfgaBlCa6CRxYIVw=;
        b=Ow96Rd3O2ZiyLBf3eBHcKhBHZGEUHaaQSE2oOTPmAPoibgby39Z9fjeeIq+jkSFlhT
         a+EhDhiRdt3YsHsJgy/vcWW4UhDjn/qaBy15XMeQzfhLg8B93/ou0wztfRXlpyXX/G4D
         2PJnzVZsJMh4czL9KKcJ1GfmgMr1+NAQkBDv/YhxY/lgsNybuEXFCThvtns+sQizyky1
         O8JDrkRJ728GD3/odoUE9RdibQ4csZEDLkY+kR7hLtarsEX6K4RRX3xbW5MnFyPasJA8
         Gh0GLYBT8MMs30CxLxBetco6hdPHt21txKvoMvt0GG2Ffjs+v+NhMBALHUMrZR0+giEt
         j5JQ==
X-Gm-Message-State: ANoB5pkm1luq2GeSl4oS1TbLiZvZpO3PfupRoiJtvJYINzgbNp/5zg4i
	39nBUU/jrl9iSrmt2zauRjLgzj8jtwPtadmdAepGkw==
X-Google-Smtp-Source: AA0mqf5lImrYjSG2qG8wHkOxPafuxpqJyZLTwqEDiwfRe0ptbYcQ09on7ZiYFobULDz+0AHmQt42G9VURGZZHsd0DAk=
X-Received: by 2002:a17:90a:e2c5:b0:214:1648:687d with SMTP id
 fr5-20020a17090ae2c500b002141648687dmr35554546pjb.78.1669183688483; Tue, 22
 Nov 2022 22:08:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-15-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-15-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 22 Nov 2022 22:07:52 -0800
Message-ID: <CAAeT=FwKuB2mAhWaeDSVQnHyDnQrLnNAuZ+Z3=KoFZe5imiwXQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/16] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to
 the guest
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221123060752.Uh6MVu7wxucaBSv1EqTBAUOFE6SK90icCKB_VL8_uJw@z>

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Now that the infrastructure is in place, bump the PMU support up
> to PMUv3p5.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
