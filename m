Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4C8C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E75624B177;
	Tue, 10 May 2022 02:04:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yLPkxX+G+32K; Tue, 10 May 2022 02:04:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0284B301;
	Tue, 10 May 2022 02:04:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E48BC4B137
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 22:38:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1c-kRH9NTw1R for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 22:38:21 -0400 (EDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com
 [209.85.128.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D01F84B104
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 22:38:21 -0400 (EDT)
Received: by mail-yw1-f169.google.com with SMTP id
 00721157ae682-2f83983782fso165081377b3.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 19:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=BPO52QBr44Bzr1xH0azS/RYPVxAq0DK85MFcX2XucZw=;
 b=JT86ApbO4rDLtelzKk4Q/0DlRg7xiTti/1AfWfvsNg8lZG2B+BfQuEZaJGnzP8CpKW
 DMF/40wNEEgVSUsy74nYYKgii47O8mCeBDajUKNSho9I8uwCTxN+Qe5TwVeLGvhnCWgy
 5ErojWR0Xx//v4OkdvAv6+v/XPbGKShR9ffNQcRGj08AoLRmV2uh9icyjTCqH1SkBI3S
 AayUpY1g7HKzaa8uWifqWsqaWSIaXjcBJzJAhKYTYCoSv0gT3H2/HcqYqHVcat6AH1UQ
 a2HKWky6TDsXySKgC2hhR4rLe5XS0G30YzAzU4F/FATZ58dyF/lCSy6bCWFerrpqTrCa
 uLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=BPO52QBr44Bzr1xH0azS/RYPVxAq0DK85MFcX2XucZw=;
 b=a6VcxJo4QPTt4USDQI3ybAqTnViYclj8i+O5YqPJXfiQyQV90Ss64IrGiMRRftYEkg
 E6Q0p6UtfN+OFVbXYJv4yTLFQ9FKzp5o3iH6oFuWC9NRgGuAUZIb6FFckNusKGuDHKX3
 yOt26IHvh1KzqW+u7KyDBcG154uEusKK/SJn7Uca+wHgHvQByyJoDMkM1TZ3KwJrH/20
 Iev/rsjOyZXSFihg2pSaWzdvoadMhEo0ZDQ1wTGuynfg1+ctCDmKbF5GIp3ZwnytpwvP
 T8vJggf1uQ/iO99DI/U1oITKMVIDowglkg+jDf/KiSgKuBhjx66my6/7UQFEXowvXnz4
 VmZg==
X-Gm-Message-State: AOAM532MA7iwzsVwf0SrWotJadyJ/aK6B2WEyu7jUq8n8ddfZnda0bST
 5imaIBjZxJWGd+hUT5g7H+qAr0M6EX9M0sXy7/U=
X-Google-Smtp-Source: ABdhPJxbovG+s+ky3Yc8xigW04JzC3pj0B0o8bnhR4lMsNn5dirjbXkA2nFy1JThd3LGiv0CwHX97WfwJfooHqhp2r0=
X-Received: by 2002:a81:c1:0:b0:2f7:d6ae:d0bf with SMTP id
 184-20020a8100c1000000b002f7d6aed0bfmr18403646ywa.369.1652150301400; 
 Mon, 09 May 2022 19:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
 <YnRGpDa/kG+9h7Jd@google.com>
 <CALzav=fK9T5YwbiTU1qq7DZuE3E+MVRGDTHpKch7W9jQ9AR8bA@mail.gmail.com>
In-Reply-To: <CALzav=fK9T5YwbiTU1qq7DZuE3E+MVRGDTHpKch7W9jQ9AR8bA@mail.gmail.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Tue, 10 May 2022 10:38:10 +0800
Message-ID: <CAJhGHyBaaOghrNr77uhi_VYjfubu_Ai2YK0RriOFPEMeJrHeqQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
To: David Matlack <dmatlack@google.com>
X-Mailman-Approved-At: Tue, 10 May 2022 02:04:42 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)" <kvm@vger.kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, May 10, 2022 at 6:10 AM David Matlack <dmatlack@google.com> wrote:

>
> +Lai Jiangshan
>
> It looks like only root pages can be passthrough, so
> kvm_mmu_child_role() can hard-code passthrough to 0. Lai do you agree?
>


Agree.

Thanks
Lai
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
