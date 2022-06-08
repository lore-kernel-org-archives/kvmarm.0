Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EC4C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 18:41:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6AC14B20A;
	Wed,  8 Jun 2022 14:41:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W2dllxUxl1Jq; Wed,  8 Jun 2022 14:41:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66CC74B271;
	Wed,  8 Jun 2022 14:41:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B6A4B20A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 14:41:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OtL2TMb79Yn6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 14:41:46 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 130194A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 14:41:45 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 60D6261C1D;
 Wed,  8 Jun 2022 18:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C728C34116;
 Wed,  8 Jun 2022 18:41:41 +0000 (UTC)
Date: Wed, 8 Jun 2022 19:41:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
Message-ID: <YqDtYULvAMQVp1pC@arm.com>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
 <CA+EHjTx328na4FDfKU-cdLX+SV4MmKfMKKrTHo5H0=iB2GTQ+A@mail.gmail.com>
 <Ypl5TdMN3J/tttNe@google.com> <87v8tgltqy.wl-maz@kernel.org>
 <CAMn1gO7mP_QTb+fkfvc6qQoN0aU6TwkExU-Wj+VR6rjBsmhs1g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMn1gO7mP_QTb+fkfvc6qQoN0aU6TwkExU-Wj+VR6rjBsmhs1g@mail.gmail.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Andy Lutomirski <luto@amacapital.net>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Mon, Jun 06, 2022 at 05:20:39PM -0700, Peter Collingbourne wrote:
> On Sat, Jun 4, 2022 at 1:26 AM Marc Zyngier <maz@kernel.org> wrote:
> > But the bigger picture here is what ensures that the host cannot mess
> > with the guest tags? I don't think we have a any mechanism to
> > guarantee that, specially on systems where the tags are only a memory
> > carve-out, which the host could map and change at will.
> 
> Right, I forgot about that. We probably only want to expose MTE to
> guests if we have some indication (through the device tree or ACPI) of
> how to protect the guest tag storage.

I think this would be useful irrespective of MTE. Some SoCs (though I
hope very rare these days) may allow for physical aliasing of RAM but if
the host stage 2 only protects one of the aliases, it's not of much use.

I am yet to fully understand how pKVM works but with the separation of
the hyp from the host kernel, it may have to actually parse the
DT/ACPI/EFI tables itself if it cannot rely on what the host kernel told
it. IIUC currently it creates an idmap at stage 2 for the host kernel,
only unmapped if the memory was assigned to a guest. But not sure what
happens with the rest of the host physical address space (devices etc.),
I presume they are fully accessible by the host kernel in stage 2.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
