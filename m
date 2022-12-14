Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15359C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 14 Dec 2022 17:08:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DD784B970;
	Wed, 14 Dec 2022 12:08:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 078DiDDHSkar; Wed, 14 Dec 2022 12:08:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 273134B971;
	Wed, 14 Dec 2022 12:08:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E0A84B960
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 04:50:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TUy6g6tjbhHX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2022 04:50:21 -0500 (EST)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 223FA43C6F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 04:50:21 -0500 (EST)
Received: by mail-pf1-f176.google.com with SMTP id t18so4031236pfq.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 01:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=Jbas8k53VpTFWCNrs3oRHT/Z65GCtCU2WQLZf0mUIGE=;
 b=afwPx6LdFoKaH5nf+ag3bcmEMnN8QxYCsgHz0tCKFfNGbcAhKAKWcHJS4u0Xa02rh9
 1zx4dWkTQ16/1Xq2qNjpEn/3zEiV+mVtkVWXwDxrtry3ggQwYtHlzleK+hm+POGHPrEa
 VR30Iiq3fwVosu3uFcFlghm/CQnobNW0jBUmqmTqKDJ18p6Vv3nTnv+YJd9Q5V9R2qRW
 rK3qglYycZi9MnKCpxTmAdk5enZysYESnQUsKy4Dui9/9KOMamkgsKJVkSAwwlSq3qfb
 OyhJNSoWvttRx7SrdvyCvHkwHTBdaB7W4Z0D/jUtQ/E84c2kEM0PIZMnID4mjv788Xgs
 gp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Jbas8k53VpTFWCNrs3oRHT/Z65GCtCU2WQLZf0mUIGE=;
 b=30KrATCCDYlZtp7dn4u9WRRPh8QLmuSS16y4A/+UBzyM7Pzp58cubllWho7vq6weof
 Cg2eSQdsclXdUiuP/JLtzp5/d2urJMef4zfTJn0afX3YoBSuIvAwdjrAEFeWQRRYLEyb
 FNAZCLkoIY7uTmMk2w6xbPmyaRlTWg+5p++U8hjshEGhq9g+o/aSb3iL41DeYZkM7XlG
 /k5v91cdhsenB9DVzaTSULojfVn1k8OxV6A4nCAovQQDIKzQnCAjzF0CLyFKtChsoQP+
 bOwa5JCYF6r9dsVBL6pZ1aXbgR/YHNzDcymL+pykaIcttav3XKmPKZbysJDUinpAkGx2
 FdWQ==
X-Gm-Message-State: ANoB5pl2vyrCiwPMXuV7CQlU+H/javN5CmBt2R9xTXyhOGzsJq+lUkZa
 YpBn3P7YsHZnhZsAB2ZEnfJXqVmT9IMDrn86FN0=
X-Google-Smtp-Source: AA0mqf7w8TIU6K2l/8MuGzXNAAZ9FRqdURji/6nctthseH2MSfKX1yiUw7Qrbh0D1Res/crh8T4uAxCut4Jl7FykNkI=
X-Received: by 2002:a63:e4a:0:b0:477:6cd0:9a04 with SMTP id
 10-20020a630e4a000000b004776cd09a04mr75781850pgo.433.1671011420030; Wed, 14
 Dec 2022 01:50:20 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com> <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
In-Reply-To: <Y5dnWgJ0ine55/hN@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Wed, 14 Dec 2022 17:50:07 +0800
Message-ID: <CAJhGHyBbjyKVEv3KcoOcPGQ28753FjR_rc9uNDEF3Dd-gNTRGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Wed, 14 Dec 2022 12:08:20 -0500
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, "Amit, Nadav" <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Atish Patra <atishp@atishpatra.org>, David Matlack <dmatlack@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Tue, Dec 13, 2022 at 1:47 AM Sean Christopherson <seanjc@google.com> wrote:

>
> My preference would be to leave .smm in x86's page role.  IMO, defining multiple
> address spaces to support SMM emulation was a mistake that should be contained to
> SMM, i.e. should never be used for any other feature.  And with CONFIG_KVM_SMM,
> even x86 can opt out.
>


I think the name ASID in kvm/x86 should be used for vmcb's ASID,
vmcs's VPID, and PCID. Using the name ASID for other purposes
would only result in unnecessary confusion.

There is a bug for shadow paging when it uses two separate sets
of memslots which are using two sets of rmap and page-tracking.

When SMM world is writing to a non-SMM page which happens to be
a guest pagetable in the non-SMM world, the write operation will
go smoothly without specially handled and the shadow page for the guest
pagetable is neither unshadowed nor marked unsync.  The shadow paging
code is unaware that the shadow page has deviated from the guest
pagetable.

It means when SMM is enabled, shadow paging should be disabled,
which also means it has to use tdp and not to use nested tdp.

Thanks
Lai
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
