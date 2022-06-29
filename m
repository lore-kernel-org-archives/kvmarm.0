Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A3FCCA481
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jun 2022 19:15:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B78764B52E;
	Wed, 29 Jun 2022 15:15:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xwxR60YuiJEw; Wed, 29 Jun 2022 15:15:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 885ED4B534;
	Wed, 29 Jun 2022 15:15:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6B54B525
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2022 15:15:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iGiuHub-FuvE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2022 15:15:16 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56B7D4B4D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2022 15:15:16 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9F797B82553;
 Wed, 29 Jun 2022 19:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E06C34114;
 Wed, 29 Jun 2022 19:15:11 +0000 (UTC)
Date: Wed, 29 Jun 2022 20:15:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <Yryku0/XU2GkcjvY@arm.com>
References: <20220623234944.141869-1-pcc@google.com> <YrXu0Uzi73pUDwye@arm.com>
 <CAMn1gO7-qVzZrAt63BJC-M8gKLw4=60iVUo6Eu8T_5y3AZnKcA@mail.gmail.com>
 <YrmXzHXv4babwbNZ@arm.com>
 <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
 <YrtBIX0/0jyAdgnz@arm.com>
 <CAMn1gO7aC1zqWDt1bAk_ds8ejuhx2obo-LE-2UwFXch=uNFoAA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMn1gO7aC1zqWDt1bAk_ds8ejuhx2obo-LE-2UwFXch=uNFoAA@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andy Lutomirski <luto@amacapital.net>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Tue, Jun 28, 2022 at 11:54:51AM -0700, Peter Collingbourne wrote:
> On Tue, Jun 28, 2022 at 10:58 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > That's why it would be interesting to see
> > the effect of using DC GZVA instead of DC ZVA for page zeroing.
> >
> > I suspect on Android you'd notice the fork() penalty a bit more with all
> > the copy-on-write having to copy tags. But we can't tell until we do
> > some benchmarks. If the penalty is indeed significant, we'll go back to
> > assessing the races here.
> 
> Okay, I can try to measure it. I do feel rather strongly though that
> we should try to avoid tagging pages as much as possible even ignoring
> the potential performance implications.
> 
> Here's one more idea: we can tag pages eagerly as you propose, but
> introduce an opt-out. For example, we introduce a MAP_NOMTE flag,
> which would prevent tag initialization as well as causing any future
> attempt to mprotect(PROT_MTE) to fail. Allocators that know that the
> memory will not be used for MTE in the future can set this flag. For
> example, Scudo can start setting this flag once MTE has been disabled
> as it has no mechanism for turning MTE back on once disabled. And that
> way we will end up with no tags on the heap in the processes with MTE
> disabled. Mappings with MAP_NOMTE would not be permitted in the guest
> memory space of MTE enabled guests. For executables mapped by the
> kernel we may consider adding a bit to the ELF program headers to
> enable MAP_NOMTE.

I don't like such negative flags and we should aim for minimal changes
to code that doesn't care about MTE. If there's a performance penalty
with zeroing the tags, we'll keep looking at the lazy tag
initialisation.

In the meantime, I'll think some more about the lazy stuff. We need at
least mte_sync_tags() fixed to set the PG_mte_tagged after the tags have
been updated (fixes the CoW + mprotect() race but probably breaks
concurrent MAP_SHARED mprotect()). We'd have to add some barriers (maybe
in a new function, set_page_tagged()). Some cases like restoring from
swap (both private and shared) have the page lock held. KVM doesn't seem
to take any page lock, so it can race with the VMM.

Anyway, I doubt we can get away with a single bit. We can't make use of
PG_locked either since set_pte_at() is called with the page either
locked or unlocked.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
