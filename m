Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C50BC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 16:50:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCA1749F16;
	Wed,  9 Mar 2022 11:50:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s2T1qbiyqspu; Wed,  9 Mar 2022 11:50:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3B0649E36;
	Wed,  9 Mar 2022 11:50:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5180D49E1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:50:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pmNmJoG+ew7c for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 11:50:50 -0500 (EST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A77349E17
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 11:50:50 -0500 (EST)
Received: by mail-wm1-f44.google.com with SMTP id
 p184-20020a1c29c1000000b0037f76d8b484so1830532wmp.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2022 08:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ZgHou8MqoXhRtzbJoo/yhan8iXTUzQE6PBiS2FKYRVk=;
 b=ApCIZr+MN6aee2cgqpPw+PV2CFMmrVy6Tba9Ix98g0JMbS/aPhT2nRYGytV5+Ew1dK
 z0tHBjwNiHk8ULLoDS6I4IZtOD1vgXLJ6jKahOF+IevRmjrWjq4mt6e2HLiiL22auFD7
 MnRfKwypFDEgPWQJnHfOysoynPTsTdtaTl0uYlV7qZCkg7zwXRBiAvgulaFHIPHCW0x5
 Hnuu1IVwWai8BPnp6D9ccORnN9fLNaPf57yibDLFRvp1pBm3n06ltkKX9Je5tohqyKmH
 OCBB1atg/D7hEWIqw31e2vKDb8speQ438g9RZRyONaVt0go3FMRBOFD7EDZjPJEfAe+j
 YQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZgHou8MqoXhRtzbJoo/yhan8iXTUzQE6PBiS2FKYRVk=;
 b=8LhB7OPY0At//uNemqLuUugOf8GE+3Vyyvb4fbTyUvNkgrYjMSaR72B4M7NUgJvb/7
 nepuc6VEq3qIkruTx2oyC5wP7D5bN+DwxO3Wr7WtDERzxW+AwjkCJwTh/7pfRmamDBJC
 QhC663p/Qm8ts0szDbGVYLMGa456jEvvewkE82bKAPOleZ3Kd87TcdmnUb3FUtVn+LC/
 mnejtlgRecBDfFb7JUOuCKnNsh7flbgh2xtZ0GhVyzD+J9MQpSBaVNeq28TEIvtQ1Eep
 IkIoM8HL+E1WGddVg5HM4MRk5J0x4osXSXkuQZBv8/C9GUh5MeyViUQ5yOf4z1MpeEYx
 HUNw==
X-Gm-Message-State: AOAM533i5v18lYjLkOWhs5zOTU7InCdeBPjAP19iyyRUrvR3f5e/gaN+
 jQz5viHU3m+JnHipyeqf1tjB4A==
X-Google-Smtp-Source: ABdhPJxsfLI0wVXG0HYqp8aGshE147e4FbNfGYA0n96plE+EG/lqB6ihUwJsiKwXUPa03ZDRH3qAhA==
X-Received: by 2002:a05:600c:3b1c:b0:389:8677:6c73 with SMTP id
 m28-20020a05600c3b1c00b0038986776c73mr210606wms.192.1646844648795; 
 Wed, 09 Mar 2022 08:50:48 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:24bb:c5c7:5788:287d])
 by smtp.gmail.com with ESMTPSA id
 v20-20020a7bcb54000000b0037fa63db8aasm5972989wmj.5.2022.03.09.08.50.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Mar 2022 08:50:48 -0800 (PST)
Date: Wed, 9 Mar 2022 16:50:45 +0000
From: Quentin Perret <qperret@google.com>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v5 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
Message-ID: <Yija5cY6j/B25Psw@google.com>
References: <20220307184935.1704614-1-kaleshsingh@google.com>
 <20220307184935.1704614-2-kaleshsingh@google.com>
 <CAE-0n52LmVRkrSNN=eJf+TYYnmesVjFv99nnetYvRWshm82rOg@mail.gmail.com>
 <CAC_TJvc6LYp95BXQc0DSBBBAZpYpixa+NyHKMLFWsBADD5Ubhg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC_TJvc6LYp95BXQc0DSBBBAZpYpixa+NyHKMLFWsBADD5Ubhg@mail.gmail.com>
Cc: "Cc: Android Kernel" <kernel-team@android.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Will Deacon <will@kernel.org>,
 Peter Collingbourne <pcc@google.com>, Marc Zyngier <maz@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <swboyd@chromium.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Tuesday 08 Mar 2022 at 15:09:18 (-0800), Kalesh Singh wrote:
> On Tue, Mar 8, 2022 at 12:21 PM Stephen Boyd <swboyd@chromium.org> wrote:
> > It looks odd to use an error pointer casted to unsigned long to return
> > from an address allocation function. Why not pass a pointer for base
> > like the function was written before and return an int from this
> > function with 0 for success and negative error value?Otherwise some
> > sort of define should made like DMA_MAPPING_ERROR and that can be used
> > to indicate to the caller that the allocation failed, or a simple zero
> > may work?
> 
> I wanted to keep consistent between the pkvm and traditional nvhe
> code. I will refactor both *alloc_private_va_range() functions to take
> a pointer and return an int error if that's preferred. There would
> still be a case of this kind of cast in
> __pkvm_create_private_mapping() which does return an unsigned long
> address or ERR_PTR(...). It looks like it was made to return the
> address to facilitate use as a hypercall (@Quentin CMIW).

Yep, passing everything by value was much easier to cross the EL1/EL2
boundary as that avoids having the hypervisor map kernel memory and all
that fun. But Stephen's point is fair, so no objection from to keep this
little dance confined to the hypercall wrapper and make the function
signature nicer and easier to use for the rest of the code.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
