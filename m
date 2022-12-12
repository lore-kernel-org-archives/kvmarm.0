Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111D4C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 22:50:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F2004B93D;
	Mon, 12 Dec 2022 17:50:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rPNl9dVzs2n9; Mon, 12 Dec 2022 17:50:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 713BD4B955;
	Mon, 12 Dec 2022 17:50:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB7D4B939
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:50:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 13N8K77ckLH3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 17:50:01 -0500 (EST)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACC484B91C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:50:01 -0500 (EST)
Received: by mail-yw1-f180.google.com with SMTP id
 00721157ae682-381662c78a9so168386477b3.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=emGR11sDGj23bwB4iDGKY/Jt07F7a624TvyLlINCb/4=;
 b=iIA/1zCE2/PdX7UwUpsCHVx2/4soMLJq+umSYNq1TIMKZ3vYOufggcHfzl2zpb3L95
 3KzRsMM6KMDNwv2INU26jqyRM70qj97aTjffNJqHOpklQjdDCkuFG/H5HyjOFryrkHsC
 WuUbOIXYNWL4NRA6iZCQSLbRHyxsEBOt+Yw5NkOMax5mZSsMG+NRAdlVCNMmHaLUJBr6
 RC6kxVfoGDnQ5XX0CU2kxeJuCxvyy75M74Im9VLDAzaDFpiYYonazefbFsiv+O87XQTC
 OANFKz6exzf3vgq07bR18r0zHtd6tggWQPlgrfF8L6R2GCpm+TNCBwJ2GvYSdlpZvSIY
 NaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=emGR11sDGj23bwB4iDGKY/Jt07F7a624TvyLlINCb/4=;
 b=Dzn3+cY8o4spivMrQk7j9az4tuRpVYV/Xxgi1i78eWKmSP/qeU05j/JDacJ6vKF1jA
 5FqmaLNOkn2ab8A6pGk8yHlWigv5j7PClxiiu84Vi4LH1JlsRG5N48nuVbPZ9FbRg0td
 CLGXxukVHxqvTcrrcXu+9+GIFolc9OlecXtmSOUvRegtui1MKgspYnFo1D2EygXLAMiC
 DJ1AwcSJRbL0FaU2Ryf8qs/ym8wIoYxcbGZop63aFeoDJJ2vgrAjfY/7rqfRrOLMeUbA
 J1H9Esi5SvqbDqrH1vN/z34Kw6pGS1Dq6VouBV+cTuPFdjBiylulmaGEHmMzUlA2Mf65
 iLMw==
X-Gm-Message-State: ANoB5pn0l/Z1s47ciAnhVO0axeJn0HSCdoRV6PN5pDHU9b1yS8033+eD
 41dZukIwlbdjcy8efTuJ8ByGSYPUY+zsCfAkK5ZdAQ==
X-Google-Smtp-Source: AA0mqf7BLbzUXAWE3wffbmFiHSNF9Kd+b9tfc4w51Pba8kylanBVygPwVEaOBfOQoKTOkaa76ZxA34hsT2ZYbKl8ZbE=
X-Received: by 2002:a0d:df0a:0:b0:35f:9c14:144a with SMTP id
 i10-20020a0ddf0a000000b0035f9c14144amr26607842ywe.209.1670885401042; Mon, 12
 Dec 2022 14:50:01 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-7-dmatlack@google.com>
 <0e159e42-ebca-c0d5-f2ae-29fa2344e720@redhat.com>
In-Reply-To: <0e159e42-ebca-c0d5-f2ae-29fa2344e720@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Dec 2022 14:49:35 -0800
Message-ID: <CALzav=efGBpf7joCwRjkF2B2VOmauuktSzRdoyWTRwVkQr1Tbw@mail.gmail.com>
Subject: Re: [RFC PATCH 06/37] KVM: MMU: Move struct kvm_mmu_page to common
 code
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 Ben Gardon <bgardon@google.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Yu Zhao <yuzhao@google.com>,
 xu xin <cgel.zte@gmail.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
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

On Mon, Dec 12, 2022 at 2:32 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/8/22 20:38, David Matlack wrote:
> > This commit increases the size of struct kvm_mmu_page by 64 bytes on
> > x86_64 (184 bytes -> 248 bytes). The size of this struct can be reduced
> > in future commits by moving TDP MMU root fields into a separate struct
> > and by dynamically allocating fields only used by the Shadow MMU.
>
> I think it's already possible to use a union like
>
>         union {
>                 struct kvm_mmu_page_arch arch;
>                 struct {
>                         struct work_struct work;
>                         void *data;
>                 };
>         };

That would potentially corrupt
kvm_mmu_page_arch.nx_huge_page_disallowed and
possible_nx_huge_page_link, both of which still need to be used by the
TDP MMU on x86.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
