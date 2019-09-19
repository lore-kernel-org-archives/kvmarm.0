Return-Path: <SRS0=YpAl=XP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MIME_HTML_MOSTLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1149C3A5A2
	for <kvmarm@archiver.kernel.org>; Fri, 20 Sep 2019 16:00:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E89002086A
	for <kvmarm@archiver.kernel.org>; Fri, 20 Sep 2019 16:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Y7/lYqaq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E89002086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sifive.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D5C94A752;
	Fri, 20 Sep 2019 12:00:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@sifive.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KnDzKt-s-23D; Fri, 20 Sep 2019 11:59:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E414A712;
	Fri, 20 Sep 2019 11:59:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E39A44A664
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 12:04:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OHx0AziMPCke for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Sep 2019 12:04:51 -0400 (EDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
 [209.85.208.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6212A4A663
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 12:04:51 -0400 (EDT)
Received: by mail-ed1-f43.google.com with SMTP id r4so3714832edy.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sifive.com; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yBCP/ZHVmI23CdAO8uLqYweH9goPLs2F7niCsg3OEJc=;
 b=Y7/lYqaq4SyBEmMyFBTFTeuz/0M4VU5w1EKcQo4I/VIY5rv5T/PfR0cstck6cwKKGT
 n/IZXP27lts6q4LbzqidKOxICxxtQ3eD7whJvHb0h9dBrlptrI8845c9FNu4VB0Qg9Lm
 aGN6FaVMzXlMEAHQsHsGI/rM1H5SkVPjYFu0+UVV3GDzfriEYFVW89/4C06dHOftyUCQ
 Mm00gebZ05evXR0BeTnZiz5yKUs3X34MQijrLd+sT8tYoc2IDEvy8f71GeyFi0FbgHVI
 lsVz1gfwFgYk0QBOPPGbMCPewsXvX2jHcj+cAOVb2G9oHb1uc/y386Ha+gWubFGc9z7Q
 wptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yBCP/ZHVmI23CdAO8uLqYweH9goPLs2F7niCsg3OEJc=;
 b=Bex4lI7gbwoV6v/zN6lTD+pb/JHx4xoyqxWFewOGqTCyB51mL3uhq3aaPKGXOBBTwx
 Brhpo2Hr9X+lbjTCeh2xo5pTS89Hx9Lu5yUNwpd1p2At1xLajHk4LBHeaZt5qoyf0TH/
 elhCPtdq58YKfj+B4R/E0xriLnNWRouE7GXo6cDCTkFnMjIq6cCaNGURQkdzfKulCr2R
 sy0m9J+c3n+CVwQdYrW8u7vCjvXP6eVGqA5SkLQbZCW1DaYZPSyRa7PtDY6P6hmH3HP3
 4g6KwbCcahwQxSTqp0uZAuFj5mAXYo5zwzIQjyKio97FCH0w56pXHZsEGNvbn+7Dwjuq
 po8A==
X-Gm-Message-State: APjAAAWZywxTs5eM1cFHTiMMehPE2HcS2tlkIAC2g6MDcnARyojxOhq0
 kbR7g3GKtFHb2ct3y75zz8MuZMhNwKwXsA==
X-Google-Smtp-Source: APXvYqxdQ8Rb/q/dG7O0Ux9iYIM0fXy/guNmml2ffpLocGEWlwM+5oji4jJ/lR+CIpxJSeBPDu+x6g==
X-Received: by 2002:a17:906:168f:: with SMTP id
 s15mr14603957ejd.109.1568909089716; 
 Thu, 19 Sep 2019 09:04:49 -0700 (PDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com.
 [209.85.221.50])
 by smtp.gmail.com with ESMTPSA id k9sm1716643edr.88.2019.09.19.09.04.47
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 Sep 2019 09:04:48 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id l3so3670676wru.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 09:04:47 -0700 (PDT)
X-Received: by 2002:adf:e7cc:: with SMTP id e12mr7737870wrn.299.1568909087289; 
 Thu, 19 Sep 2019 09:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <1568896556-28769-1-git-send-email-guoren@kernel.org>
In-Reply-To: <1568896556-28769-1-git-send-email-guoren@kernel.org>
From: Andrew Waterman <andrew@sifive.com>
Date: Thu, 19 Sep 2019 09:04:35 -0700
X-Gmail-Original-Message-ID: <CA++6G0AzDs7w3gjjT4tDZjWBiMPf4Bvd36Ak0xdzfcJdPriKiw@mail.gmail.com>
Message-ID: <CA++6G0AzDs7w3gjjT4tDZjWBiMPf4Bvd36Ak0xdzfcJdPriKiw@mail.gmail.com>
Subject: Re: [tech-privileged] [RFC PATCH V1] riscv-privileged: Add broadcast
 mode to sfence.vma
To: Guo Ren <guoren@kernel.org>
X-Mailman-Approved-At: Fri, 20 Sep 2019 11:59:58 -0400
Cc: catalin.marinas@arm.com, palmer@sifive.com, will.deacon@arm.com,
 Atish.Patra@wdc.com, julien.grall@arm.com, gary@garyguo.net,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 jean-philippe@linaro.org, linux-csky@vger.kernel.org, rppt@linux.ibm.com,
 Guo Ren <ren_guo@c-sky.com>, benh@kernel.crashing.org,
 jacob.jun.pan@linux.intel.com, tech-privileged@lists.riscv.org,
 marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
 feiteng_li@c-sky.com, Anup.Patel@wdc.com, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, dwmw2@infradead.org
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
Content-Type: multipart/mixed; boundary="===============4614402778956254927=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4614402778956254927==
Content-Type: multipart/alternative; boundary="000000000000d539180592ea1c65"

--000000000000d539180592ea1c65
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This needs to be discussed and debated at length; proposing edits to the
spec at this stage is putting the cart before the horse!

We shouldn=E2=80=99t change the definition of the existing SFENCE.VMA instr=
uction
to accomplish this. It=E2=80=99s also not abundantly clear to me that this =
should
be an instruction: TLB shootdown looks more like MMIO.

On Thu, Sep 19, 2019 at 5:36 AM Guo Ren <guoren@kernel.org> wrote:

> From: Guo Ren <ren_guo@c-sky.com>
>
> The patch is for https://github.com/riscv/riscv-isa-manual
>
> The proposal has been talked in LPC-2019 RISC-V MC ref [1]. Here is the
> formal patch.
>
> Introduction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Using the Hardware TLB broadcast invalidation instruction to maintain the
> system TLB is a good choice and it'll simplify the system software design=
.
> The proposal hopes to add a broadcast mode to the sfence.vma in the
> riscv-privilege specification. To support the sfence.vma broadcast mode,
> there are two modification introduced below:
>
>  1) Add PGD.PPN (root page table's PPN) as the unique identifier of the
>     address space in addition to asid/vmid. Compared to the dynamically
>     changed asid/vmid, PGD.PPN is fixed throughout the address space life
>     cycle. This feature enables uniform address space identification
>     between different TLB systems (actually, it's difficult to unify the
>     asid/vmid between the CPU system and the IOMMU system, because their
>     mechanisms are different)
>
>  2) Modify the definition of the sfence.vma instruction from synchronous
>     mode to asynchronous mode, which means that the completion of the TLB
>     operation is not guaranteed when the sfence.vma instruction retires.
>     It needs to be completed by checking the flag bit on the hart. The
>     sfence.vma request finish can notify the software by generating an
>     interrupt. This function alleviates the large delay of TLB invalidati=
on
>     in the PCI ATS system.
>
> Add S1/S2.PGD.PPN for ASID/VMID
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>
> PGD is global directory (defined in linux) and PPN is page physical numbe=
r
> (defined in riscv-spec). PGD.PNN corresponds to the root page table point=
er
> of the address space, i.e. mm->pgd (linux concept).
>
> In CPU/IOMMU TLB, we use asid/vmid to distinguish the address space of
> process or virtual machine. Due to the limitation of id encoding, it can
> only represent a part(window) of the address space. S1/S2.PGD.PPN are the
> root page table's PPNs of the address spaces and S1/S2.PGD.PPN are the
> unique identifier of the address spaces.
>
> For the CPU SMP system, you can use context switch to perform the necessa=
ry
> software mechanism to ensure that the asid/vmid on all harts is consisten=
t
> (please refer to the arm64 asid mechanism). In this way, the TLB broadcas=
t
> invalidation instruction can determine the address space processed on all
> harts by asid/vmid.
>
> Different from the CPU SMP system, there is no context switch for the
> DMA-IOMMU system, so the unification with the CPU asid/vmid cannot be
> guaranteed. So we need a unique identifier for the address space to
> establish a communication bridge between the TLBs of different systems.
>
> That is PGD.PPN (for virtualization scenarios: S1/S2.PGD.PPN)
>
> current:
>  sfence.vma  rs1 =3D vaddr, rs2 =3D asid
>  hfence.vvma rs1 =3D vaddr, rs2 =3D asid
>  hfence.gvma rs1 =3D gaddr, rs2 =3D vmid
>
> proposed:
>  sfence.vma  rs1 =3D vaddr, rs2 =3D mode:ppn:asid
>  hfence.vvma rs1 =3D vaddr, rs2 =3D mode:ppn:asid
>  hfence.gvma rs1 =3D gaddr, rs2 =3D mode:ppn:vmid
>
>  mode      - broadcast | local
>  ppn       - the PPN of the address space of the root page table
>  vmid/asid - the window identifier of the address space
>
> At the Linux Plumber Conference 2019 RISCV-MC, ref:[1], we've showed two
> IOMMU examples to explain how it work with hardware.
>
> 1) In a lightweight IOMMU system (up to 64 address spaces), the hardware
>    could directly convert PGD.PPN into DID (IOMMU ASID)
>
> 2) For the PCI ATS scenario, its IO ASID/VMID encoding space can support
>    a very large number of address spaces. We use two reverse mapping
>    tables to let the hardware translate S1/S2.PGD.PPN into IO ASID/VMID.
>
> ASYNC BROADCAST SFENCE.VMA
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
> To support the high latency broadcast sfence.vma operation in the PCI ATS
> usage scenario, we modify the sfence.vma from synchronous mode to
> asynchronous mode. (For simpler implementation, if hardware only implemen=
t
> synchronous mode and software still work in asynchronous mode)
>
> To implement the asynchronous mode, 3 features are added:
>  1) sstatus:TLBI
>     A "status bit - TLBI" is added to the sstatus register. The TLBI stat=
us
>     bit indicates if there are still outstanding sfence.vma requests on t=
he
>     current hart.
>     Value:
>       1: sfence.vma requests are not completed.
>       0: all sfece.vma requests completed, request queue is empty.
>
>  2) sstatus:TLBIC
>     A "control bits - TLBIC" is added to sstatus register. The TLBIC
> control
>     bits are controlled by software.
>     "Write 1" will trigger the current hart check to see if there are sti=
ll
>     outstanding sfence.vma requests. If there are unfinished requests, an
>     interrupt will be generated when the request is completed, notifying
> the
>     software that all of the current sfence.vma requests have been
> completed.
>     "Write 0" will cause nothing.
>
>  3) supervisor interrupt register (sip & sie):TLBI finish interrupt
>     A per-hart interrupt is added to supervisor interrupt registers.
>     When all sfence.vma requests are completed and sstatus:TLBIC has been
>     triggered, hart will receive a TLBI finish interrupt. Just like timer=
,
>     software and external interrupt's definition in sip & sie.
>
> Fake code:
>
> flush_tlb_page(vma, addr) {
>     asid =3D cpu_asid(vma->vm_mm);
>     ppn =3D PFN_DOWN(vma->vm_mm->pgd);
>
>     sfence.vma (addr, 1|PPN_OFFSET(ppn)|asid); //1. start request
>
>     while(sstatus:TLBI) if (time_out() > 1ms) break; //2. loop check
>
>     while (sstatus:TLBI) {
>         ...
>         set sstatus:TLBIC;
>         wait_TLBI_finish_interrupt(); //3. wait irq, io_schedule
>     }
> }
>
> Here we give 2 level check:
>  1) loop check sstatus:TLBI, CPU could response Interrupt.
>  2) set sstatus:TLBIC and wait for irq, CPU schedule out for other task.
>
> ACE-DVM Example
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Honestly, "broadcasting addr, asid, vmid, S1/S2.PGD.PPN to interconnects"
> and "ASYNC SFENCE.VMA" could be implemented by ACE-DVM protocol ref [2].
>
> There are 3 types of transactions in DVM:
>
>  - DVM operation
>    Send all information to the interconnect, including addr, asid,
>    S1.PGD.PPN, vmid, S2.PGD.PPN.
>
>  - DVM synchronization
>    Check that all DVM operations have been completed. If not, it will use
>    state machine to wait DVM complete requests.
>
>  - DVM complete
>    Return transaction from components, eg: IOMMU. If hart has received al=
l
>    DVM completes which are triggered by sfence.vma instructions and
>    "sstatus:TLBIC" has been set, a TLBI finish interrupt is triggered.
>
> (Actually, we do not need to implement the above functions strictly
>  according to the ACE specification :P )
>
>  1: https://www.linuxplumbersconf.org/event/4/contributions/307/
>  2: AMBA AXI and ACE Protocol Specification - Distributed Virtual Memory
>     Transactions"
>
> Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> Reviewed-by: Li Feiteng <feiteng_li@c-sky.com>
> ---
>  src/hypervisor.tex |  43 ++++++++-------
>  src/supervisor.tex | 155
> +++++++++++++++++++++++++++++++++++++++++------------
>  2 files changed, 143 insertions(+), 55 deletions(-)
>
> diff --git a/src/hypervisor.tex b/src/hypervisor.tex
> index 47b90b2..3718819 100644
> --- a/src/hypervisor.tex
> +++ b/src/hypervisor.tex
> @@ -1094,15 +1094,15 @@ The hypervisor extension adds two new privileged
> fence instructions.
>  \multicolumn{1}{c|}{opcode} \\
>  \hline
>  7 & 5 & 5 & 3 & 5 & 7 \\
> -HFENCE.GVMA & vmid & gaddr & PRIV & 0 & SYSTEM \\
> -HFENCE.VVMA & asid & vaddr & PRIV & 0 & SYSTEM \\
> +HFENCE.GVMA & mode:ppn:vmid & gaddr & PRIV & 0 & SYSTEM \\
> +HFENCE.VVMA & mode:ppn:asid & vaddr & PRIV & 0 & SYSTEM \\
>  \end{tabular}
>  \end{center}
>
>  The hypervisor memory-management fence instructions, HFENCE.GVMA and
>  HFENCE.VVMA, are valid only in HS-mode when {\tt mstatus}.TVM=3D0, or in
> M-mode
>  (irrespective of {\tt mstatus}.TVM).
> -These instructions perform a function similar to SFENCE.VMA
> +These instructions perform a function similar to SFENCE.VMA
> (broadcast/local)
>  (Section~\ref{sec:sfence.vma}), except applying to the guest-physical
>  memory-management data structures controlled by CSR {\tt hgatp}
> (HFENCE.GVMA)
>  or the VS-level memory-management data structures controlled by CSR {\tt
> vsatp}
> @@ -1136,11 +1136,10 @@ An HFENCE.VVMA instruction applies only to a
> single virtual machine, identified
>  by the setting of {\tt hgatp}.VMID when HFENCE.VVMA executes.
>  \end{commentary}
>
> -When {\em rs2}$\neq${\tt x0}, bits XLEN-1:ASIDMAX of the value held in
> {\em
> -rs2} are reserved for future use and should be zeroed by software and
> ignored
> -by current implementations.
> -Furthermore, if ASIDLEN~$<$~ASIDMAX, the implementation shall ignore bit=
s
> -ASIDMAX-1:ASIDLEN of the value held in {\em rs2}.
> +When {\em rs2}$\neq${\tt x0}, bits contain 3 informations: mode, ppn,
> asid.
> +1) mode control HFENCE.VVMA broadcast or not.
> +2) ppn is the root page talbe's PPN of the asid address space.
> +3) asid is the identifier of process in virtual machine.
>
>  \begin{commentary}
>  Simpler implementations of HFENCE.VVMA can ignore the guest virtual
> address in
> @@ -1168,11 +1167,10 @@ physical addresses in PMP address registers
> (Section~\ref{sec:pmp}) and in page
>  table entries (Sections \ref{sec:sv32}, \ref{sec:sv39},
> and~\ref{sec:sv48}).
>  \end{commentary}
>
> -When {\em rs2}$\neq${\tt x0}, bits XLEN-1:VMIDMAX of the value held in
> {\em
> -rs2} are reserved for future use and should be zeroed by software and
> ignored
> -by current implementations.
> -Furthermore, if VMIDLEN~$<$~VMIDMAX, the implementation shall ignore bit=
s
> -VMIDMAX-1:VMIDLEN of the value held in {\em rs2}.
> +When {\em rs2}$\neq${\tt x0}, bits contain 3 informations: mode, vmid,
> ppn.
> +1) mode control HFENCE.GVMA broadcast or not.
> +2) ppn is the root page talbe's PPN of the vmid address space.
> +3) vmid is the identifier of virtual machine.
>
>  \begin{commentary}
>  Simpler implementations of HFENCE.GVMA can ignore the guest physical
> address in
> @@ -1567,21 +1565,22 @@ register.
>  \subsection{Memory-Management Fences}
>
>  The behavior of the SFENCE.VMA instruction is affected by the current
> -virtualization mode V.  When V=3D0, the virtual-address argument is an
> HS-level
> -virtual address, and the ASID argument is an HS-level ASID.
> +virtualization mode V.  When V=3D0, the rs1 argument is an HS-level
> +virtual address, and the rs2 argument is an HS-level ASID and root page
> table's PPN.
>  The instruction orders stores only to HS-level address-translation
> structures
>  with subsequent HS-level address translations.
>
> -When V=3D1, the virtual-address argument to SFENCE.VMA is a guest virtua=
l
> -address within the current virtual machine, and the ASID argument is a
> VS-level
> -ASID within the current virtual machine.
> +When V=3D1, the rs1 argument to SFENCE.VMA is a guest virtual
> +address within the current virtual machine, and the rs2 argument is a
> VS-level
> +ASID and root page table's PPN within the current virtual machine.
>  The current virtual machine is identified by the VMID field of CSR {\tt
> hgatp},
> -and the effective ASID can be considered to be the combination of this
> VMID
> -with the VS-level ASID.
> +and the effective ASID and root page table's PPN can be considered to be
> the
> +combination of this VMID and root page table's PPN with the VS-level ASI=
D
> and
> +root page table's PPN.
>  The SFENCE.VMA instruction orders stores only to the VS-level
>  address-translation structures with subsequent VS-level address
> translations
> -for the same virtual machine, i.e., only when {\tt hgatp}.VMID is the
> same as
> -when the SFENCE.VMA executed.
> +for the same virtual machine, i.e., only when {\tt hgatp}.VMID and {\\tt
> hgatp}.PPN is
> +the same as when the SFENCE.VMA executed.
>
>  Hypervisor instructions HFENCE.GVMA and HFENCE.VVMA provide additional
>  memory-management fences to complement SFENCE.VMA.
> diff --git a/src/supervisor.tex b/src/supervisor.tex
> index ba3ced5..2877b7a 100644
> --- a/src/supervisor.tex
> +++ b/src/supervisor.tex
> @@ -47,10 +47,12 @@ register keeps track of the processor's current
> operating state.
>  \begin{center}
>  \setlength{\tabcolsep}{4pt}
>  \scalebox{0.95}{
> -\begin{tabular}{cWcccccWccccWcc}
> +\begin{tabular}{cccWcccccWccccWcc}
>  \\
>  \instbit{31} &
> -\instbitrange{30}{20} &
> +\instbit{30} &
> +\instbit{29} &
> +\instbitrange{28}{20} &
>  \instbit{19} &
>  \instbit{18} &
>  \instbit{17} &
> @@ -66,6 +68,8 @@ register keeps track of the processor's current
> operating state.
>  \instbit{0} \\
>  \hline
>  \multicolumn{1}{|c|}{SD} &
> +\multicolumn{1}{|c|}{TLBI} &
> +\multicolumn{1}{|c|}{TLBIC} &
>  \multicolumn{1}{c|}{\wpri} &
>  \multicolumn{1}{c|}{MXR} &
>  \multicolumn{1}{c|}{SUM} &
> @@ -82,7 +86,7 @@ register keeps track of the processor's current
> operating state.
>  \multicolumn{1}{c|}{\wpri}
>  \\
>  \hline
> -1 & 11 & 1 & 1 & 1 & 2 & 2 & 4 & 1 & 1 & 1 & 1 & 3 & 1 & 1 \\
> +1 & 1 & 1 & 10 & 1 & 1 & 1 & 2 & 2 & 4 & 1 & 1 & 1 & 1 & 3 & 1 & 1 \\
>  \end{tabular}}
>  \end{center}
>  }
> @@ -95,10 +99,12 @@ register keeps track of the processor's current
> operating state.
>  {\footnotesize
>  \begin{center}
>  \setlength{\tabcolsep}{4pt}
> -\begin{tabular}{cMFScccc}
> +\begin{tabular}{cccMFScccc}
>  \\
>  \instbit{SXLEN-1} &
> -\instbitrange{SXLEN-2}{34} &
> +\instbit{SXLEN-2} &
> +\instbit{SXLEN-3} &
> +\instbitrange{SXLEN-4}{34} &
>  \instbitrange{33}{32} &
>  \instbitrange{31}{20} &
>  \instbit{19} &
> @@ -107,6 +113,8 @@ register keeps track of the processor's current
> operating state.
>   \\
>  \hline
>  \multicolumn{1}{|c|}{SD} &
> +\multicolumn{1}{|c|}{TLBI} &
> +\multicolumn{1}{|c|}{TLBIC} &
>  \multicolumn{1}{c|}{\wpri} &
>  \multicolumn{1}{c|}{UXL[1:0]} &
>  \multicolumn{1}{c|}{\wpri} &
> @@ -115,7 +123,7 @@ register keeps track of the processor's current
> operating state.
>  \multicolumn{1}{c|}{\wpri} &
>   \\
>  \hline
> -1 & SXLEN-35 & 2 & 12 & 1 & 1 & 1 & \\
> +1 & 1 & 1 & SXLEN-37 & 2 & 12 & 1 & 1 & 1 & \\
>  \end{tabular}
>  \begin{tabular}{cWWFccccWcc}
>  \\
> @@ -152,6 +160,17 @@ register keeps track of the processor's current
> operating state.
>  \label{sstatusreg}
>  \end{figure*}
>
> +The TLBI (read-only) bit indicates that any async sfence.vma operations
> are
> +still pended on the hart. The value:0 means that there is no sfence.vma
> +operations pending and value:1 means that there are still sfence.vma
> operations
> +pending on the hart.
> +
> +When the sstatus:TLBIC bit is written 1, it triggers the hardware to
> check if
> +there are any TLB invalidate operations being pended. When all operation=
s
> are
> +finished, a TLB Invalidate finish interrupt will be triggered
> +(see Section~\ref{sipreg}). When the sstatus:TLBIC bit is written 0, it
> will
> +cause nothing. Reading sstatus:TLBIC bit will alaways return 0.
> +
>  The SPP bit indicates the privilege level at which a hart was executing
> before
>  entering supervisor mode.  When a trap is taken, SPP is set to 0 if the
> trap
>  originated from user mode, or 1 otherwise.  When an SRET instruction
> @@ -329,8 +348,10 @@ SXLEN-bit read/write register containing interrupt
> enable bits.
>  {\footnotesize
>  \begin{center}
>  \setlength{\tabcolsep}{4pt}
> -\begin{tabular}{KcFcFcc}
> -\instbitrange{SXLEN-1}{10} &
> +\begin{tabular}{KcFcFcFcc}
> +\instbitrange{SXLEN-1}{14} &
> +\instbit{13} &
> +\instbitrange{12}{10} &
>  \instbit{9} &
>  \instbitrange{8}{6} &
>  \instbit{5} &
> @@ -339,6 +360,8 @@ SXLEN-bit read/write register containing interrupt
> enable bits.
>  \instbit{0} \\
>  \hline
>  \multicolumn{1}{|c|}{\wpri} &
> +\multicolumn{1}{c|}{STLBIP} &
> +\multicolumn{1}{|c|}{\wpri} &
>  \multicolumn{1}{c|}{SEIP} &
>  \multicolumn{1}{c|}{\wpri} &
>  \multicolumn{1}{c|}{STIP} &
> @@ -346,7 +369,7 @@ SXLEN-bit read/write register containing interrupt
> enable bits.
>  \multicolumn{1}{c|}{SSIP} &
>  \multicolumn{1}{c|}{\wpri} \\
>  \hline
> -SXLEN-10 & 1 & 3 & 1 & 3 & 1 & 1 \\
> +SXLEN-14 & 1 & 3 & 1 & 3 & 1 & 3 & 1 & 1 \\
>  \end{tabular}
>  \end{center}
>  }
> @@ -359,8 +382,10 @@ SXLEN-10 & 1 & 3 & 1 & 3 & 1 & 1 \\
>  {\footnotesize
>  \begin{center}
>  \setlength{\tabcolsep}{4pt}
> -\begin{tabular}{KcFcFcc}
> -\instbitrange{SXLEN-1}{10} &
> +\begin{tabular}{KcFcFcFcc}
> +\instbitrange{SXLEN-1}{14} &
> +\instbit{13} &
> +\instbitrange{12}{10} &
>  \instbit{9} &
>  \instbitrange{8}{6} &
>  \instbit{5} &
> @@ -369,6 +394,8 @@ SXLEN-10 & 1 & 3 & 1 & 3 & 1 & 1 \\
>  \instbit{0} \\
>  \hline
>  \multicolumn{1}{|c|}{\wpri} &
> +\multicolumn{1}{c|}{STLBIE} &
> +\multicolumn{1}{|c|}{\wpri} &
>  \multicolumn{1}{c|}{SEIE} &
>  \multicolumn{1}{c|}{\wpri} &
>  \multicolumn{1}{c|}{STIE} &
> @@ -376,7 +403,7 @@ SXLEN-10 & 1 & 3 & 1 & 3 & 1 & 1 \\
>  \multicolumn{1}{c|}{SSIE} &
>  \multicolumn{1}{c|}{\wpri} \\
>  \hline
> -SXLEN-10 & 1 & 3 & 1 & 3 & 1 & 1 \\
> +SXLEN-14 & 1 & 3 & 1 & 3 & 1 & 3 & 1 & 1 \\
>  \end{tabular}
>  \end{center}
>  }
> @@ -410,6 +437,12 @@ when the SEIE bit in the {\tt sie} register is
> clear.  The implementation
>  should provide facilities to mask, unmask, and query the cause of extern=
al
>  interrupts.
>
> +A supervisor-level TLB Invalidate finish interrupt is pending if the
> STLBIP bit
> +in the {\tt sip} register is set.  Supervisor-level TLB Invalidate finis=
h
> +interrupts are disabled when the STLBIE bit in the {\tt sie} register is
> clear.
> +When hart tlb invalidate operations are finished, hardware will change
> sstatus:TLBI
> +bit from 1 to 0 and trigger TLB Invalidate finish interrupt.
> +
>  \begin{commentary}
>  The {\tt sip} and {\tt sie} registers are subsets of the {\tt mip} and
> {\tt
>  mie} registers.  Reading any field, or writing any writable field, of {\=
tt
> @@ -598,7 +631,9 @@ so is only guaranteed to hold supported exception
> codes.
>    1         & 5               & Supervisor timer interrupt \\
>    1         & 6--8            & {\em Reserved} \\
>    1         & 9               & Supervisor external interrupt \\
> -  1         & 10--15          & {\em Reserved} \\
> +  1         & 10--11          & {\em Reserved} \\
> +  1         & 12              & Supervisor TLBI finish interrupt \\
> +  1         & 13--15          & {\em Reserved} \\
>    1         & $\ge$16         & {\em Available for platform use} \\ \hli=
ne
>    0         & 0               & Instruction address misaligned \\
>    0         & 1               & Instruction access fault \\
> @@ -884,7 +919,7 @@ provided.
>  \multicolumn{1}{c|}{opcode} \\
>  \hline
>  7 & 5 & 5 & 3 & 5 & 7 \\
> -SFENCE.VMA & asid & vaddr & PRIV & 0 & SYSTEM \\
> +SFENCE.VMA & mode:ppn:asid & vaddr & LOCAL & 0 & SYSTEM \\
>  \end{tabular}
>  \end{center}
>
> @@ -899,21 +934,70 @@ from that hart to the memory-management data
> structures.
>  Further details on the behavior of this instruction are
>  described in Section~\ref{virt-control} and Section~\ref{pmp-vmem}.
>
> +SFENCE.VMA is defined as an asynchronous completion instruction, which
> means
> +that the TLB operation is not guaranteed to complete when the instructio=
n
> retires.
> +Software need check sstatus:TLBI to determine all TLB operations complet=
e.
> +The sstatus:TLBI described in Section~\ref{sstatus}. When hardware chang=
e
> +sstatus:TLBI bit from 1 to 0, the TLB Invalidate finish interrupt will b=
e
> +triggered.
> +
>  \begin{commentary}
> -The SFENCE.VMA is used to flush any local hardware caches related to
> +The SFENCE.VMA is used to flush any local/remote hardware caches related
> to
>  address translation.  It is specified as a fence rather than a TLB
>  flush to provide cleaner semantics with respect to which instructions
>  are affected by the flush operation and to support a wider variety of
>  dynamic caching structures and memory-management schemes.  SFENCE.VMA
>  is also used by higher privilege levels to synchronize page table
> -writes and the address translation hardware.
> +writes and the address translation hardware. There is a mode bit to
> determine
> +sfence.vma would broadcast on interconnect or not.
>  \end{commentary}
>
> -SFENCE.VMA orders only the local hart's implicit references to the
> -memory-management data structures.
> +\begin{figure}[h!]
> +{\footnotesize
> +\begin{center}
> +\begin{tabular}{c@{}E@{}K}
> +\instbit{31} &
> +\instbitrange{30}{9} &
> +\instbitrange{8}{0} \\
> +\hline
> +\multicolumn{1}{|c|}{{\tt MODE}} &
> +\multicolumn{1}{|c|}{{\tt PPN (root page table)}} &
> +\multicolumn{1}{|c|}{{\tt ASID}} \\
> +\hline
> +1 & 22 & 9 \\
> +\end{tabular}
> +\end{center}
> +}
> +\vspace{-0.1in}
> +\caption{RV32 sfence.vma rs2 format.}
> +\label{rv32satp}
> +\end{figure}
> +
> +\begin{figure}[h!]
> +{\footnotesize
> +\begin{center}
> +\begin{tabular}{@{}S@{}T@{}U}
> +\instbitrange{63}{60} &
> +\instbitrange{59}{16} &
> +\instbitrange{15}{0} \\
> +\hline
> +\multicolumn{1}{|c|}{{\tt MODE}} &
> +\multicolumn{1}{|c|}{{\tt PPN (root page table)}} &
> +\multicolumn{1}{|c|}{{\tt ASID}} \\
> +\hline
> +4 & 44 & 16 \\
> +\end{tabular}
> +\end{center}
> +}
> +\vspace{-0.1in}
> +\caption{RV64 sfence.vma rs2 format, for MODE values, only highest bit:6=
3
> is
> +valid and others are reserved.}
> +\label{rv64satp}
> +\end{figure}
>
>  \begin{commentary}
> -Consequently, other harts must be notified separately when the
> +The mode's highest bit could control sfence.vma behavior with 1:broadcas=
t
> or 0:local.
> +If only have mode:local, other harts must be notified separately when th=
e
>  memory-management data structures have been modified.
>  One approach is to use 1)
>  a local data fence to ensure local writes are visible globally, then
> @@ -928,8 +1012,17 @@ modified for a single address mapping (i.e., one
> page or superpage), {\em rs1}
>  can specify a virtual address within that mapping to effect a translatio=
n
>  fence for that mapping only.  Furthermore, for the common case that the
>  translation data structures have only been modified for a single
> address-space
> -identifier, {\em rs2} can specify the address space.  The behavior of
> -SFENCE.VMA depends on {\em rs1} and {\em rs2} as follows:
> +identifier, {\em rs2} can specify the address space with {\tt satp} form=
at
> +which include asid and root page table's PPN information.
> +
> +\begin{commentary}
> +We use ASID and root page table's PPN to determine address space and the
> format
> +stored in rs2 is similar with {\tt satp} described in
> Section~\ref{sec:satp}.
> +ASID are used by local harts and root page table's PPN of the asid are
> used by
> +other different TLB systems, eg: IOMMU.
> +\end{commentary}
> +
> +The behavior of SFENCE.VMA depends on {\em rs1} and {\em rs2} as follows=
:
>
>  \begin{itemize}
>  \item If {\em rs1}=3D{\tt x0} and {\em rs2}=3D{\tt x0}, the fence orders=
 all
> @@ -939,23 +1032,18 @@ SFENCE.VMA depends on {\em rs1} and {\em rs2} as
> follows:
>        all reads and writes made to any level of the page tables, but onl=
y
>        for the address space identified by integer register {\em rs2}.
>        Accesses to {\em global} mappings (see
> Section~\ref{sec:translation})
> -      are not ordered.
> +      are not ordered. The mode field in rs2 is determine broadcast or
> local.
>  \item If {\em rs1}$\neq${\tt x0} and {\em rs2}=3D{\tt x0}, the fence ord=
ers
>        only reads and writes made to the leaf page table entry
> corresponding
>        to the virtual address in {\em rs1}, for all address spaces.
>  \item If {\em rs1}$\neq${\tt x0} and {\em rs2}$\neq${\tt x0}, the fence
>        orders only reads and writes made to the leaf page table entry
>        corresponding to the virtual address in {\em rs1}, for the address
> -      space identified by integer register {\em rs2}.
> +      space identified by integer register {\em rs2}. The mode field in
> rs2
> +      is determine broadcast or local.
>        Accesses to global mappings are not ordered.
>  \end{itemize}
>
> -When {\em rs2}$\neq${\tt x0}, bits SXLEN-1:ASIDMAX of the value held in
> {\em
> -rs2} are reserved for future use and should be zeroed by software and
> ignored
> -by current implementations.  Furthermore, if ASIDLEN~$<$~ASIDMAX, the
> -implementation shall ignore bits ASIDMAX-1:ASIDLEN of the value held in
> {\em
> -rs2}.
> -
>  \begin{commentary}
>  Simpler implementations can ignore the virtual address in {\em rs1} and
>  the ASID value in {\em rs2} and always perform a global fence.
> @@ -994,7 +1082,7 @@ can execute the same SFENCE.VMA instruction while a
> different ASID is loaded
>  into {\tt satp}, provided the next time {\tt satp} is loaded with the
> recycled
>  ASID, it is simultaneously loaded with the new page table.
>
> -\item If the implementation does not provide ASIDs, or software chooses =
to
> +\item If the implementation does not provide ASIDs and PPNs, or software
> chooses to
>  always use ASID 0, then after every {\tt satp} write, software should
> execute
>  SFENCE.VMA with {\em rs1}=3D{\tt x0}.  In the common case that no global
>  translations have been modified, {\em rs2} should be set to a register
> other than
> @@ -1003,13 +1091,14 @@ not flushed.
>
>  \item If software modifies a non-leaf PTE, it should execute SFENCE.VMA
> with
>  {\em rs1}=3D{\tt x0}.  If any PTE along the traversal path had its G bit
> set,
> -{\em rs2} must be {\tt x0}; otherwise, {\em rs2} should be set to the
> ASID for
> -which the translation is being modified.
> +{\em rs2} must be {\tt x0}; otherwise, {\em rs2} should be set to the
> ASID and
> +root page table's PPN for which the translation is being modified.
>
>  \item If software modifies a leaf PTE, it should execute SFENCE.VMA with
> {\em
>  rs1} set to a virtual address within the page.  If any PTE along the
> traversal
>  path had its G bit set, {\em rs2} must be {\tt x0}; otherwise, {\em rs2}
> -should be set to the ASID for which the translation is being modified.
> +should be set to the ASID and root page table's PPN for which the
> translation
> +is being modified.
>
>  \item For the special cases of increasing the permissions on a leaf PTE
> and
>  changing an invalid PTE to a valid leaf, software may choose to execute
> --
> 2.7.4
>
>
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
> Links: You receive all messages sent to this group.
>
> View/Reply Online (#810):
> https://lists.riscv.org/g/tech-privileged/message/810
> Mute This Topic: https://lists.riscv.org/mt/34198986/1677273
> Group Owner: tech-privileged+owner@lists.riscv.org
> Unsubscribe: https://lists.riscv.org/g/tech-privileged/unsub  [
> andrew@sifive.com]
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
>
>

--000000000000d539180592ea1c65
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><div dir=3D"auto">This needs to be discussed and debated at length; pr=
oposing edits to the spec at this stage is putting the cart before the hors=
e!</div></div><div dir=3D"auto"><br></div><div dir=3D"auto">We shouldn=E2=
=80=99t change the definition of the existing SFENCE.VMA instruction to acc=
omplish this. It=E2=80=99s also not abundantly clear to me that this should=
 be an instruction: TLB shootdown looks more like MMIO.</div><div><br><div =
class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Sep 19,=
 2019 at 5:36 AM Guo Ren &lt;<a href=3D"mailto:guoren@kernel.org">guoren@ke=
rnel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">From: Guo R=
en &lt;<a href=3D"mailto:ren_guo@c-sky.com" target=3D"_blank">ren_guo@c-sky=
.com</a>&gt;<br>
<br>
The patch is for <a href=3D"https://github.com/riscv/riscv-isa-manual" rel=
=3D"noreferrer" target=3D"_blank">https://github.com/riscv/riscv-isa-manual=
</a><br>
<br>
The proposal has been talked in LPC-2019 RISC-V MC ref [1]. Here is the<br>
formal patch.<br>
<br>
Introduction<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
Using the Hardware TLB broadcast invalidation instruction to maintain the<b=
r>
system TLB is a good choice and it&#39;ll simplify the system software desi=
gn.<br>
The proposal hopes to add a broadcast mode to the sfence.vma in the<br>
riscv-privilege specification. To support the sfence.vma broadcast mode,<br=
>
there are two modification introduced below:<br>
<br>
=C2=A01) Add PGD.PPN (root page table&#39;s PPN) as the unique identifier o=
f the<br>
=C2=A0 =C2=A0 address space in addition to asid/vmid. Compared to the dynam=
ically<br>
=C2=A0 =C2=A0 changed asid/vmid, PGD.PPN is fixed throughout the address sp=
ace life<br>
=C2=A0 =C2=A0 cycle. This feature enables uniform address space identificat=
ion<br>
=C2=A0 =C2=A0 between different TLB systems (actually, it&#39;s difficult t=
o unify the<br>
=C2=A0 =C2=A0 asid/vmid between the CPU system and the IOMMU system, becaus=
e their<br>
=C2=A0 =C2=A0 mechanisms are different)<br>
<br>
=C2=A02) Modify the definition of the sfence.vma instruction from synchrono=
us<br>
=C2=A0 =C2=A0 mode to asynchronous mode, which means that the completion of=
 the TLB<br>
=C2=A0 =C2=A0 operation is not guaranteed when the sfence.vma instruction r=
etires.<br>
=C2=A0 =C2=A0 It needs to be completed by checking the flag bit on the hart=
. The<br>
=C2=A0 =C2=A0 sfence.vma request finish can notify the software by generati=
ng an<br>
=C2=A0 =C2=A0 interrupt. This function alleviates the large delay of TLB in=
validation<br>
=C2=A0 =C2=A0 in the PCI ATS system.<br>
<br>
Add S1/S2.PGD.PPN for ASID/VMID<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D<br>
<br>
PGD is global directory (defined in linux) and PPN is page physical number<=
br>
(defined in riscv-spec). PGD.PNN corresponds to the root page table pointer=
<br>
of the address space, i.e. mm-&gt;pgd (linux concept).<br>
<br>
In CPU/IOMMU TLB, we use asid/vmid to distinguish the address space of<br>
process or virtual machine. Due to the limitation of id encoding, it can<br=
>
only represent a part(window) of the address space. S1/S2.PGD.PPN are the<b=
r>
root page table&#39;s PPNs of the address spaces and S1/S2.PGD.PPN are the<=
br>
unique identifier of the address spaces.<br>
<br>
For the CPU SMP system, you can use context switch to perform the necessary=
<br>
software mechanism to ensure that the asid/vmid on all harts is consistent<=
br>
(please refer to the arm64 asid mechanism). In this way, the TLB broadcast<=
br>
invalidation instruction can determine the address space processed on all<b=
r>
harts by asid/vmid.<br>
<br>
Different from the CPU SMP system, there is no context switch for the<br>
DMA-IOMMU system, so the unification with the CPU asid/vmid cannot be<br>
guaranteed. So we need a unique identifier for the address space to<br>
establish a communication bridge between the TLBs of different systems.<br>
<br>
That is PGD.PPN (for virtualization scenarios: S1/S2.PGD.PPN)<br>
<br>
current:<br>
=C2=A0sfence.vma=C2=A0 rs1 =3D vaddr, rs2 =3D asid<br>
=C2=A0hfence.vvma rs1 =3D vaddr, rs2 =3D asid<br>
=C2=A0hfence.gvma rs1 =3D gaddr, rs2 =3D vmid<br>
<br>
proposed:<br>
=C2=A0sfence.vma=C2=A0 rs1 =3D vaddr, rs2 =3D mode:ppn:asid<br>
=C2=A0hfence.vvma rs1 =3D vaddr, rs2 =3D mode:ppn:asid<br>
=C2=A0hfence.gvma rs1 =3D gaddr, rs2 =3D mode:ppn:vmid<br>
<br>
=C2=A0mode=C2=A0 =C2=A0 =C2=A0 - broadcast | local<br>
=C2=A0ppn=C2=A0 =C2=A0 =C2=A0 =C2=A0- the PPN of the address space of the r=
oot page table<br>
=C2=A0vmid/asid - the window identifier of the address space<br>
<br>
At the Linux Plumber Conference 2019 RISCV-MC, ref:[1], we&#39;ve showed tw=
o<br>
IOMMU examples to explain how it work with hardware.<br>
<br>
1) In a lightweight IOMMU system (up to 64 address spaces), the hardware<br=
>
=C2=A0 =C2=A0could directly convert PGD.PPN into DID (IOMMU ASID)<br>
<br>
2) For the PCI ATS scenario, its IO ASID/VMID encoding space can support<br=
>
=C2=A0 =C2=A0a very large number of address spaces. We use two reverse mapp=
ing<br>
=C2=A0 =C2=A0tables to let the hardware translate S1/S2.PGD.PPN into IO ASI=
D/VMID.<br>
<br>
ASYNC BROADCAST SFENCE.VMA<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D<br>
<br>
To support the high latency broadcast sfence.vma operation in the PCI ATS<b=
r>
usage scenario, we modify the sfence.vma from synchronous mode to<br>
asynchronous mode. (For simpler implementation, if hardware only implement<=
br>
synchronous mode and software still work in asynchronous mode)<br>
<br>
To implement the asynchronous mode, 3 features are added:<br>
=C2=A01) sstatus:TLBI<br>
=C2=A0 =C2=A0 A &quot;status bit - TLBI&quot; is added to the sstatus regis=
ter. The TLBI status<br>
=C2=A0 =C2=A0 bit indicates if there are still outstanding sfence.vma reque=
sts on the<br>
=C2=A0 =C2=A0 current hart.<br>
=C2=A0 =C2=A0 Value:<br>
=C2=A0 =C2=A0 =C2=A0 1: sfence.vma requests are not completed.<br>
=C2=A0 =C2=A0 =C2=A0 0: all sfece.vma requests completed, request queue is =
empty.<br>
<br>
=C2=A02) sstatus:TLBIC<br>
=C2=A0 =C2=A0 A &quot;control bits - TLBIC&quot; is added to sstatus regist=
er. The TLBIC control<br>
=C2=A0 =C2=A0 bits are controlled by software.<br>
=C2=A0 =C2=A0 &quot;Write 1&quot; will trigger the current hart check to se=
e if there are still<br>
=C2=A0 =C2=A0 outstanding sfence.vma requests. If there are unfinished requ=
ests, an<br>
=C2=A0 =C2=A0 interrupt will be generated when the request is completed, no=
tifying the<br>
=C2=A0 =C2=A0 software that all of the current sfence.vma requests have bee=
n completed.<br>
=C2=A0 =C2=A0 &quot;Write 0&quot; will cause nothing.<br>
<br>
=C2=A03) supervisor interrupt register (sip &amp; sie):TLBI finish interrup=
t<br>
=C2=A0 =C2=A0 A per-hart interrupt is added to supervisor interrupt registe=
rs.<br>
=C2=A0 =C2=A0 When all sfence.vma requests are completed and sstatus:TLBIC =
has been<br>
=C2=A0 =C2=A0 triggered, hart will receive a TLBI finish interrupt. Just li=
ke timer,<br>
=C2=A0 =C2=A0 software and external interrupt&#39;s definition in sip &amp;=
 sie.<br>
<br>
Fake code:<br>
<br>
flush_tlb_page(vma, addr) {<br>
=C2=A0 =C2=A0 asid =3D cpu_asid(vma-&gt;vm_mm);<br>
=C2=A0 =C2=A0 ppn =3D PFN_DOWN(vma-&gt;vm_mm-&gt;pgd);<br>
<br>
=C2=A0 =C2=A0 sfence.vma (addr, 1|PPN_OFFSET(ppn)|asid); //1. start request=
<br>
<br>
=C2=A0 =C2=A0 while(sstatus:TLBI) if (time_out() &gt; 1ms) break; //2. loop=
 check<br>
<br>
=C2=A0 =C2=A0 while (sstatus:TLBI) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ...<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 set sstatus:TLBIC;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_TLBI_finish_interrupt(); //3. wait irq, io=
_schedule<br>
=C2=A0 =C2=A0 }<br>
}<br>
<br>
Here we give 2 level check:<br>
=C2=A01) loop check sstatus:TLBI, CPU could response Interrupt.<br>
=C2=A02) set sstatus:TLBIC and wait for irq, CPU schedule out for other tas=
k.<br>
<br>
ACE-DVM Example<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
<br>
Honestly, &quot;broadcasting addr, asid, vmid, S1/S2.PGD.PPN to interconnec=
ts&quot;<br>
and &quot;ASYNC SFENCE.VMA&quot; could be implemented by ACE-DVM protocol r=
ef [2].<br>
<br>
There are 3 types of transactions in DVM:<br>
<br>
=C2=A0- DVM operation<br>
=C2=A0 =C2=A0Send all information to the interconnect, including addr, asid=
,<br>
=C2=A0 =C2=A0S1.PGD.PPN, vmid, S2.PGD.PPN.<br>
<br>
=C2=A0- DVM synchronization<br>
=C2=A0 =C2=A0Check that all DVM operations have been completed. If not, it =
will use<br>
=C2=A0 =C2=A0state machine to wait DVM complete requests.<br>
<br>
=C2=A0- DVM complete<br>
=C2=A0 =C2=A0Return transaction from components, eg: IOMMU. If hart has rec=
eived all<br>
=C2=A0 =C2=A0DVM completes which are triggered by sfence.vma instructions a=
nd<br>
=C2=A0 =C2=A0&quot;sstatus:TLBIC&quot; has been set, a TLBI finish interrup=
t is triggered.<br>
<br>
(Actually, we do not need to implement the above functions strictly<br>
=C2=A0according to the ACE specification :P )<br>
<br>
=C2=A01: <a href=3D"https://www.linuxplumbersconf.org/event/4/contributions=
/307/" rel=3D"noreferrer" target=3D"_blank">https://www.linuxplumbersconf.o=
rg/event/4/contributions/307/</a><br>
=C2=A02: AMBA AXI and ACE Protocol Specification - Distributed Virtual Memo=
ry<br>
=C2=A0 =C2=A0 Transactions&quot;<br>
<br>
Signed-off-by: Guo Ren &lt;<a href=3D"mailto:ren_guo@c-sky.com" target=3D"_=
blank">ren_guo@c-sky.com</a>&gt;<br>
Reviewed-by: Li Feiteng &lt;<a href=3D"mailto:feiteng_li@c-sky.com" target=
=3D"_blank">feiteng_li@c-sky.com</a>&gt;<br>
---<br>
=C2=A0src/hypervisor.tex |=C2=A0 43 ++++++++-------<br>
=C2=A0src/supervisor.tex | 155 +++++++++++++++++++++++++++++++++++++++++---=
---------<br>
=C2=A02 files changed, 143 insertions(+), 55 deletions(-)<br>
<br>
diff --git a/src/hypervisor.tex b/src/hypervisor.tex<br>
index 47b90b2..3718819 100644<br>
--- a/src/hypervisor.tex<br>
+++ b/src/hypervisor.tex<br>
@@ -1094,15 +1094,15 @@ The hypervisor extension adds two new privileged fe=
nce instructions.<br>
=C2=A0\multicolumn{1}{c|}{opcode} \\<br>
=C2=A0\hline<br>
=C2=A07 &amp; 5 &amp; 5 &amp; 3 &amp; 5 &amp; 7 \\<br>
-HFENCE.GVMA &amp; vmid &amp; gaddr &amp; PRIV &amp; 0 &amp; SYSTEM \\<br>
-HFENCE.VVMA &amp; asid &amp; vaddr &amp; PRIV &amp; 0 &amp; SYSTEM \\<br>
+HFENCE.GVMA &amp; mode:ppn:vmid &amp; gaddr &amp; PRIV &amp; 0 &amp; SYSTE=
M \\<br>
+HFENCE.VVMA &amp; mode:ppn:asid &amp; vaddr &amp; PRIV &amp; 0 &amp; SYSTE=
M \\<br>
=C2=A0\end{tabular}<br>
=C2=A0\end{center}<br>
<br>
=C2=A0The hypervisor memory-management fence instructions, HFENCE.GVMA and<=
br>
=C2=A0HFENCE.VVMA, are valid only in HS-mode when {\tt mstatus}.TVM=3D0, or=
 in M-mode<br>
=C2=A0(irrespective of {\tt mstatus}.TVM).<br>
-These instructions perform a function similar to SFENCE.VMA<br>
+These instructions perform a function similar to SFENCE.VMA (broadcast/loc=
al)<br>
=C2=A0(Section~\ref{sec:sfence.vma}), except applying to the guest-physical=
<br>
=C2=A0memory-management data structures controlled by CSR {\tt hgatp} (HFEN=
CE.GVMA)<br>
=C2=A0or the VS-level memory-management data structures controlled by CSR {=
\tt vsatp}<br>
@@ -1136,11 +1136,10 @@ An HFENCE.VVMA instruction applies only to a single=
 virtual machine, identified<br>
=C2=A0by the setting of {\tt hgatp}.VMID when HFENCE.VVMA executes.<br>
=C2=A0\end{commentary}<br>
<br>
-When {\em rs2}$\neq${\tt x0}, bits XLEN-1:ASIDMAX of the value held in {\e=
m<br>
-rs2} are reserved for future use and should be zeroed by software and igno=
red<br>
-by current implementations.<br>
-Furthermore, if ASIDLEN~$&lt;$~ASIDMAX, the implementation shall ignore bi=
ts<br>
-ASIDMAX-1:ASIDLEN of the value held in {\em rs2}.<br>
+When {\em rs2}$\neq${\tt x0}, bits contain 3 informations: mode, ppn, asid=
.<br>
+1) mode control HFENCE.VVMA broadcast or not.<br>
+2) ppn is the root page talbe&#39;s PPN of the asid address space.<br>
+3) asid is the identifier of process in virtual machine.<br>
<br>
=C2=A0\begin{commentary}<br>
=C2=A0Simpler implementations of HFENCE.VVMA can ignore the guest virtual a=
ddress in<br>
@@ -1168,11 +1167,10 @@ physical addresses in PMP address registers (Sectio=
n~\ref{sec:pmp}) and in page<br>
=C2=A0table entries (Sections \ref{sec:sv32}, \ref{sec:sv39}, and~\ref{sec:=
sv48}).<br>
=C2=A0\end{commentary}<br>
<br>
-When {\em rs2}$\neq${\tt x0}, bits XLEN-1:VMIDMAX of the value held in {\e=
m<br>
-rs2} are reserved for future use and should be zeroed by software and igno=
red<br>
-by current implementations.<br>
-Furthermore, if VMIDLEN~$&lt;$~VMIDMAX, the implementation shall ignore bi=
ts<br>
-VMIDMAX-1:VMIDLEN of the value held in {\em rs2}.<br>
+When {\em rs2}$\neq${\tt x0}, bits contain 3 informations: mode, vmid, ppn=
.<br>
+1) mode control HFENCE.GVMA broadcast or not.<br>
+2) ppn is the root page talbe&#39;s PPN of the vmid address space.<br>
+3) vmid is the identifier of virtual machine.<br>
<br>
=C2=A0\begin{commentary}<br>
=C2=A0Simpler implementations of HFENCE.GVMA can ignore the guest physical =
address in<br>
@@ -1567,21 +1565,22 @@ register.<br>
=C2=A0\subsection{Memory-Management Fences}<br>
<br>
=C2=A0The behavior of the SFENCE.VMA instruction is affected by the current=
<br>
-virtualization mode V.=C2=A0 When V=3D0, the virtual-address argument is a=
n HS-level<br>
-virtual address, and the ASID argument is an HS-level ASID.<br>
+virtualization mode V.=C2=A0 When V=3D0, the rs1 argument is an HS-level<b=
r>
+virtual address, and the rs2 argument is an HS-level ASID and root page ta=
ble&#39;s PPN.<br>
=C2=A0The instruction orders stores only to HS-level address-translation st=
ructures<br>
=C2=A0with subsequent HS-level address translations.<br>
<br>
-When V=3D1, the virtual-address argument to SFENCE.VMA is a guest virtual<=
br>
-address within the current virtual machine, and the ASID argument is a VS-=
level<br>
-ASID within the current virtual machine.<br>
+When V=3D1, the rs1 argument to SFENCE.VMA is a guest virtual<br>
+address within the current virtual machine, and the rs2 argument is a VS-l=
evel<br>
+ASID and root page table&#39;s PPN within the current virtual machine.<br>
=C2=A0The current virtual machine is identified by the VMID field of CSR {\=
tt hgatp},<br>
-and the effective ASID can be considered to be the combination of this VMI=
D<br>
-with the VS-level ASID.<br>
+and the effective ASID and root page table&#39;s PPN can be considered to =
be the<br>
+combination of this VMID and root page table&#39;s PPN with the VS-level A=
SID and<br>
+root page table&#39;s PPN.<br>
=C2=A0The SFENCE.VMA instruction orders stores only to the VS-level<br>
=C2=A0address-translation structures with subsequent VS-level address trans=
lations<br>
-for the same virtual machine, i.e., only when {\tt hgatp}.VMID is the same=
 as<br>
-when the SFENCE.VMA executed.<br>
+for the same virtual machine, i.e., only when {\tt hgatp}.VMID and {\\tt h=
gatp}.PPN is<br>
+the same as when the SFENCE.VMA executed.<br>
<br>
=C2=A0Hypervisor instructions HFENCE.GVMA and HFENCE.VVMA provide additiona=
l<br>
=C2=A0memory-management fences to complement SFENCE.VMA.<br>
diff --git a/src/supervisor.tex b/src/supervisor.tex<br>
index ba3ced5..2877b7a 100644<br>
--- a/src/supervisor.tex<br>
+++ b/src/supervisor.tex<br>
@@ -47,10 +47,12 @@ register keeps track of the processor&#39;s current ope=
rating state.<br>
=C2=A0\begin{center}<br>
=C2=A0\setlength{\tabcolsep}{4pt}<br>
=C2=A0\scalebox{0.95}{<br>
-\begin{tabular}{cWcccccWccccWcc}<br>
+\begin{tabular}{cccWcccccWccccWcc}<br>
=C2=A0\\<br>
=C2=A0\instbit{31} &amp;<br>
-\instbitrange{30}{20} &amp;<br>
+\instbit{30} &amp;<br>
+\instbit{29} &amp;<br>
+\instbitrange{28}{20} &amp;<br>
=C2=A0\instbit{19} &amp;<br>
=C2=A0\instbit{18} &amp;<br>
=C2=A0\instbit{17} &amp;<br>
@@ -66,6 +68,8 @@ register keeps track of the processor&#39;s current opera=
ting state.<br>
=C2=A0\instbit{0} \\<br>
=C2=A0\hline<br>
=C2=A0\multicolumn{1}{|c|}{SD} &amp;<br>
+\multicolumn{1}{|c|}{TLBI} &amp;<br>
+\multicolumn{1}{|c|}{TLBIC} &amp;<br>
=C2=A0\multicolumn{1}{c|}{\wpri} &amp;<br>
=C2=A0\multicolumn{1}{c|}{MXR} &amp;<br>
=C2=A0\multicolumn{1}{c|}{SUM} &amp;<br>
@@ -82,7 +86,7 @@ register keeps track of the processor&#39;s current opera=
ting state.<br>
=C2=A0\multicolumn{1}{c|}{\wpri}<br>
=C2=A0\\<br>
=C2=A0\hline<br>
-1 &amp; 11 &amp; 1 &amp; 1 &amp; 1 &amp; 2 &amp; 2 &amp; 4 &amp; 1 &amp; 1=
 &amp; 1 &amp; 1 &amp; 3 &amp; 1 &amp; 1 \\<br>
+1 &amp; 1 &amp; 1 &amp; 10 &amp; 1 &amp; 1 &amp; 1 &amp; 2 &amp; 2 &amp; 4=
 &amp; 1 &amp; 1 &amp; 1 &amp; 1 &amp; 3 &amp; 1 &amp; 1 \\<br>
=C2=A0\end{tabular}}<br>
=C2=A0\end{center}<br>
=C2=A0}<br>
@@ -95,10 +99,12 @@ register keeps track of the processor&#39;s current ope=
rating state.<br>
=C2=A0{\footnotesize<br>
=C2=A0\begin{center}<br>
=C2=A0\setlength{\tabcolsep}{4pt}<br>
-\begin{tabular}{cMFScccc}<br>
+\begin{tabular}{cccMFScccc}<br>
=C2=A0\\<br>
=C2=A0\instbit{SXLEN-1} &amp;<br>
-\instbitrange{SXLEN-2}{34} &amp;<br>
+\instbit{SXLEN-2} &amp;<br>
+\instbit{SXLEN-3} &amp;<br>
+\instbitrange{SXLEN-4}{34} &amp;<br>
=C2=A0\instbitrange{33}{32} &amp;<br>
=C2=A0\instbitrange{31}{20} &amp;<br>
=C2=A0\instbit{19} &amp;<br>
@@ -107,6 +113,8 @@ register keeps track of the processor&#39;s current ope=
rating state.<br>
=C2=A0 \\<br>
=C2=A0\hline<br>
=C2=A0\multicolumn{1}{|c|}{SD} &amp;<br>
+\multicolumn{1}{|c|}{TLBI} &amp;<br>
+\multicolumn{1}{|c|}{TLBIC} &amp;<br>
=C2=A0\multicolumn{1}{c|}{\wpri} &amp;<br>
=C2=A0\multicolumn{1}{c|}{UXL[1:0]} &amp;<br>
=C2=A0\multicolumn{1}{c|}{\wpri} &amp;<br>
@@ -115,7 +123,7 @@ register keeps track of the processor&#39;s current ope=
rating state.<br>
=C2=A0\multicolumn{1}{c|}{\wpri} &amp;<br>
=C2=A0 \\<br>
=C2=A0\hline<br>
-1 &amp; SXLEN-35 &amp; 2 &amp; 12 &amp; 1 &amp; 1 &amp; 1 &amp; \\<br>
+1 &amp; 1 &amp; 1 &amp; SXLEN-37 &amp; 2 &amp; 12 &amp; 1 &amp; 1 &amp; 1 =
&amp; \\<br>
=C2=A0\end{tabular}<br>
=C2=A0\begin{tabular}{cWWFccccWcc}<br>
=C2=A0\\<br>
@@ -152,6 +160,17 @@ register keeps track of the processor&#39;s current op=
erating state.<br>
=C2=A0\label{sstatusreg}<br>
=C2=A0\end{figure*}<br>
<br>
+The TLBI (read-only) bit indicates that any async sfence.vma operations ar=
e<br>
+still pended on the hart. The value:0 means that there is no sfence.vma<br=
>
+operations pending and value:1 means that there are still sfence.vma opera=
tions<br>
+pending on the hart.<br>
+<br>
+When the sstatus:TLBIC bit is written 1, it triggers the hardware to check=
 if<br>
+there are any TLB invalidate operations being pended. When all operations =
are<br>
+finished, a TLB Invalidate finish interrupt will be triggered<br>
+(see Section~\ref{sipreg}). When the sstatus:TLBIC bit is written 0, it wi=
ll<br>
+cause nothing. Reading sstatus:TLBIC bit will alaways return 0.<br>
+<br>
=C2=A0The SPP bit indicates the privilege level at which a hart was executi=
ng before<br>
=C2=A0entering supervisor mode.=C2=A0 When a trap is taken, SPP is set to 0=
 if the trap<br>
=C2=A0originated from user mode, or 1 otherwise.=C2=A0 When an SRET instruc=
tion<br>
@@ -329,8 +348,10 @@ SXLEN-bit read/write register containing interrupt ena=
ble bits.<br>
=C2=A0{\footnotesize<br>
=C2=A0\begin{center}<br>
=C2=A0\setlength{\tabcolsep}{4pt}<br>
-\begin{tabular}{KcFcFcc}<br>
-\instbitrange{SXLEN-1}{10} &amp;<br>
+\begin{tabular}{KcFcFcFcc}<br>
+\instbitrange{SXLEN-1}{14} &amp;<br>
+\instbit{13} &amp;<br>
+\instbitrange{12}{10} &amp;<br>
=C2=A0\instbit{9} &amp;<br>
=C2=A0\instbitrange{8}{6} &amp;<br>
=C2=A0\instbit{5} &amp;<br>
@@ -339,6 +360,8 @@ SXLEN-bit read/write register containing interrupt enab=
le bits.<br>
=C2=A0\instbit{0} \\<br>
=C2=A0\hline<br>
=C2=A0\multicolumn{1}{|c|}{\wpri} &amp;<br>
+\multicolumn{1}{c|}{STLBIP} &amp;<br>
+\multicolumn{1}{|c|}{\wpri} &amp;<br>
=C2=A0\multicolumn{1}{c|}{SEIP} &amp;<br>
=C2=A0\multicolumn{1}{c|}{\wpri} &amp;<br>
=C2=A0\multicolumn{1}{c|}{STIP} &amp;<br>
@@ -346,7 +369,7 @@ SXLEN-bit read/write register containing interrupt enab=
le bits.<br>
=C2=A0\multicolumn{1}{c|}{SSIP} &amp;<br>
=C2=A0\multicolumn{1}{c|}{\wpri} \\<br>
=C2=A0\hline<br>
-SXLEN-10 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp; 1 \\<br>
+SXLEN-14 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp; 1 \=
\<br>
=C2=A0\end{tabular}<br>
=C2=A0\end{center}<br>
=C2=A0}<br>
@@ -359,8 +382,10 @@ SXLEN-10 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp;=
 1 \\<br>
=C2=A0{\footnotesize<br>
=C2=A0\begin{center}<br>
=C2=A0\setlength{\tabcolsep}{4pt}<br>
-\begin{tabular}{KcFcFcc}<br>
-\instbitrange{SXLEN-1}{10} &amp;<br>
+\begin{tabular}{KcFcFcFcc}<br>
+\instbitrange{SXLEN-1}{14} &amp;<br>
+\instbit{13} &amp;<br>
+\instbitrange{12}{10} &amp;<br>
=C2=A0\instbit{9} &amp;<br>
=C2=A0\instbitrange{8}{6} &amp;<br>
=C2=A0\instbit{5} &amp;<br>
@@ -369,6 +394,8 @@ SXLEN-10 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp; =
1 \\<br>
=C2=A0\instbit{0} \\<br>
=C2=A0\hline<br>
=C2=A0\multicolumn{1}{|c|}{\wpri} &amp;<br>
+\multicolumn{1}{c|}{STLBIE} &amp;<br>
+\multicolumn{1}{|c|}{\wpri} &amp;<br>
=C2=A0\multicolumn{1}{c|}{SEIE} &amp;<br>
=C2=A0\multicolumn{1}{c|}{\wpri} &amp;<br>
=C2=A0\multicolumn{1}{c|}{STIE} &amp;<br>
@@ -376,7 +403,7 @@ SXLEN-10 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp; =
1 \\<br>
=C2=A0\multicolumn{1}{c|}{SSIE} &amp;<br>
=C2=A0\multicolumn{1}{c|}{\wpri} \\<br>
=C2=A0\hline<br>
-SXLEN-10 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp; 1 \\<br>
+SXLEN-14 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp; 3 &amp; 1 &amp; 1 \=
\<br>
=C2=A0\end{tabular}<br>
=C2=A0\end{center}<br>
=C2=A0}<br>
@@ -410,6 +437,12 @@ when the SEIE bit in the {\tt sie} register is clear.=
=C2=A0 The implementation<br>
=C2=A0should provide facilities to mask, unmask, and query the cause of ext=
ernal<br>
=C2=A0interrupts.<br>
<br>
+A supervisor-level TLB Invalidate finish interrupt is pending if the STLBI=
P bit<br>
+in the {\tt sip} register is set.=C2=A0 Supervisor-level TLB Invalidate fi=
nish<br>
+interrupts are disabled when the STLBIE bit in the {\tt sie} register is c=
lear.<br>
+When hart tlb invalidate operations are finished, hardware will change sst=
atus:TLBI<br>
+bit from 1 to 0 and trigger TLB Invalidate finish interrupt.<br>
+<br>
=C2=A0\begin{commentary}<br>
=C2=A0The {\tt sip} and {\tt sie} registers are subsets of the {\tt mip} an=
d {\tt<br>
=C2=A0mie} registers.=C2=A0 Reading any field, or writing any writable fiel=
d, of {\tt<br>
@@ -598,7 +631,9 @@ so is only guaranteed to hold supported exception codes=
.<br>
=C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 5=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; Supervisor timer interrupt \\<br>
=C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 6--8=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 &amp; {\em Reserved} \\<br>
=C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 9=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; Supervisor external interrupt \\<b=
r>
-=C2=A0 1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 10--15=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 &amp; {\em Reserved} \\<br>
+=C2=A0 1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 10--11=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 &amp; {\em Reserved} \\<br>
+=C2=A0 1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 12=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 &amp; Supervisor TLBI finish interrupt \\<br>
+=C2=A0 1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 13--15=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 &amp; {\em Reserved} \\<br>
=C2=A0 =C2=A01=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; $\ge$16=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0&amp; {\em Available for platform use} \\ \hline<br>
=C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 0=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; Instruction address misaligned \\<=
br>
=C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; 1=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp; Instruction access fault \\<br>
@@ -884,7 +919,7 @@ provided.<br>
=C2=A0\multicolumn{1}{c|}{opcode} \\<br>
=C2=A0\hline<br>
=C2=A07 &amp; 5 &amp; 5 &amp; 3 &amp; 5 &amp; 7 \\<br>
-SFENCE.VMA &amp; asid &amp; vaddr &amp; PRIV &amp; 0 &amp; SYSTEM \\<br>
+SFENCE.VMA &amp; mode:ppn:asid &amp; vaddr &amp; LOCAL &amp; 0 &amp; SYSTE=
M \\<br>
=C2=A0\end{tabular}<br>
=C2=A0\end{center}<br>
<br>
@@ -899,21 +934,70 @@ from that hart to the memory-management data structur=
es.<br>
=C2=A0Further details on the behavior of this instruction are<br>
=C2=A0described in Section~\ref{virt-control} and Section~\ref{pmp-vmem}.<b=
r>
<br>
+SFENCE.VMA is defined as an asynchronous completion instruction, which mea=
ns<br>
+that the TLB operation is not guaranteed to complete when the instruction =
retires.<br>
+Software need check sstatus:TLBI to determine all TLB operations complete.=
<br>
+The sstatus:TLBI described in Section~\ref{sstatus}. When hardware change<=
br>
+sstatus:TLBI bit from 1 to 0, the TLB Invalidate finish interrupt will be<=
br>
+triggered.<br>
+<br>
=C2=A0\begin{commentary}<br>
-The SFENCE.VMA is used to flush any local hardware caches related to<br>
+The SFENCE.VMA is used to flush any local/remote hardware caches related t=
o<br>
=C2=A0address translation.=C2=A0 It is specified as a fence rather than a T=
LB<br>
=C2=A0flush to provide cleaner semantics with respect to which instructions=
<br>
=C2=A0are affected by the flush operation and to support a wider variety of=
<br>
=C2=A0dynamic caching structures and memory-management schemes.=C2=A0 SFENC=
E.VMA<br>
=C2=A0is also used by higher privilege levels to synchronize page table<br>
-writes and the address translation hardware.<br>
+writes and the address translation hardware. There is a mode bit to determ=
ine<br>
+sfence.vma would broadcast on interconnect or not.<br>
=C2=A0\end{commentary}<br>
<br>
-SFENCE.VMA orders only the local hart&#39;s implicit references to the<br>
-memory-management data structures.<br>
+\begin{figure}[h!]<br>
+{\footnotesize<br>
+\begin{center}<br>
+\begin{tabular}{c@{}E@{}K}<br>
+\instbit{31} &amp;<br>
+\instbitrange{30}{9} &amp;<br>
+\instbitrange{8}{0} \\<br>
+\hline<br>
+\multicolumn{1}{|c|}{{\tt MODE}} &amp;<br>
+\multicolumn{1}{|c|}{{\tt PPN (root page table)}} &amp;<br>
+\multicolumn{1}{|c|}{{\tt ASID}} \\<br>
+\hline<br>
+1 &amp; 22 &amp; 9 \\<br>
+\end{tabular}<br>
+\end{center}<br>
+}<br>
+\vspace{-0.1in}<br>
+\caption{RV32 sfence.vma rs2 format.}<br>
+\label{rv32satp}<br>
+\end{figure}<br>
+<br>
+\begin{figure}[h!]<br>
+{\footnotesize<br>
+\begin{center}<br>
+\begin{tabular}{@{}S@{}T@{}U}<br>
+\instbitrange{63}{60} &amp;<br>
+\instbitrange{59}{16} &amp;<br>
+\instbitrange{15}{0} \\<br>
+\hline<br>
+\multicolumn{1}{|c|}{{\tt MODE}} &amp;<br>
+\multicolumn{1}{|c|}{{\tt PPN (root page table)}} &amp;<br>
+\multicolumn{1}{|c|}{{\tt ASID}} \\<br>
+\hline<br>
+4 &amp; 44 &amp; 16 \\<br>
+\end{tabular}<br>
+\end{center}<br>
+}<br>
+\vspace{-0.1in}<br>
+\caption{RV64 sfence.vma rs2 format, for MODE values, only highest bit:63 =
is<br>
+valid and others are reserved.}<br>
+\label{rv64satp}<br>
+\end{figure}<br>
<br>
=C2=A0\begin{commentary}<br>
-Consequently, other harts must be notified separately when the<br>
+The mode&#39;s highest bit could control sfence.vma behavior with 1:broadc=
ast or 0:local.<br>
+If only have mode:local, other harts must be notified separately when the<=
br>
=C2=A0memory-management data structures have been modified.<br>
=C2=A0One approach is to use 1)<br>
=C2=A0a local data fence to ensure local writes are visible globally, then<=
br>
@@ -928,8 +1012,17 @@ modified for a single address mapping (i.e., one page=
 or superpage), {\em rs1}<br>
=C2=A0can specify a virtual address within that mapping to effect a transla=
tion<br>
=C2=A0fence for that mapping only.=C2=A0 Furthermore, for the common case t=
hat the<br>
=C2=A0translation data structures have only been modified for a single addr=
ess-space<br>
-identifier, {\em rs2} can specify the address space.=C2=A0 The behavior of=
<br>
-SFENCE.VMA depends on {\em rs1} and {\em rs2} as follows:<br>
+identifier, {\em rs2} can specify the address space with {\tt satp} format=
<br>
+which include asid and root page table&#39;s PPN information.<br>
+<br>
+\begin{commentary}<br>
+We use ASID and root page table&#39;s PPN to determine address space and t=
he format<br>
+stored in rs2 is similar with {\tt satp} described in Section~\ref{sec:sat=
p}.<br>
+ASID are used by local harts and root page table&#39;s PPN of the asid are=
 used by<br>
+other different TLB systems, eg: IOMMU.<br>
+\end{commentary}<br>
+<br>
+The behavior of SFENCE.VMA depends on {\em rs1} and {\em rs2} as follows:<=
br>
<br>
=C2=A0\begin{itemize}<br>
=C2=A0\item If {\em rs1}=3D{\tt x0} and {\em rs2}=3D{\tt x0}, the fence ord=
ers all<br>
@@ -939,23 +1032,18 @@ SFENCE.VMA depends on {\em rs1} and {\em rs2} as fol=
lows:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0all reads and writes made to any level of the pa=
ge tables, but only<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0for the address space identified by integer regi=
ster {\em rs2}.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0Accesses to {\em global} mappings (see Section~\=
ref{sec:translation})<br>
-=C2=A0 =C2=A0 =C2=A0 are not ordered.<br>
+=C2=A0 =C2=A0 =C2=A0 are not ordered. The mode field in rs2 is determine b=
roadcast or local.<br>
=C2=A0\item If {\em rs1}$\neq${\tt x0} and {\em rs2}=3D{\tt x0}, the fence =
orders<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0only reads and writes made to the leaf page tabl=
e entry corresponding<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0to the virtual address in {\em rs1}, for all add=
ress spaces.<br>
=C2=A0\item If {\em rs1}$\neq${\tt x0} and {\em rs2}$\neq${\tt x0}, the fen=
ce<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0orders only reads and writes made to the leaf pa=
ge table entry<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0corresponding to the virtual address in {\em rs1=
}, for the address<br>
-=C2=A0 =C2=A0 =C2=A0 space identified by integer register {\em rs2}.<br>
+=C2=A0 =C2=A0 =C2=A0 space identified by integer register {\em rs2}. The m=
ode field in rs2<br>
+=C2=A0 =C2=A0 =C2=A0 is determine broadcast or local.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0Accesses to global mappings are not ordered.<br>
=C2=A0\end{itemize}<br>
<br>
-When {\em rs2}$\neq${\tt x0}, bits SXLEN-1:ASIDMAX of the value held in {\=
em<br>
-rs2} are reserved for future use and should be zeroed by software and igno=
red<br>
-by current implementations.=C2=A0 Furthermore, if ASIDLEN~$&lt;$~ASIDMAX, =
the<br>
-implementation shall ignore bits ASIDMAX-1:ASIDLEN of the value held in {\=
em<br>
-rs2}.<br>
-<br>
=C2=A0\begin{commentary}<br>
=C2=A0Simpler implementations can ignore the virtual address in {\em rs1} a=
nd<br>
=C2=A0the ASID value in {\em rs2} and always perform a global fence.<br>
@@ -994,7 +1082,7 @@ can execute the same SFENCE.VMA instruction while a di=
fferent ASID is loaded<br>
=C2=A0into {\tt satp}, provided the next time {\tt satp} is loaded with the=
 recycled<br>
=C2=A0ASID, it is simultaneously loaded with the new page table.<br>
<br>
-\item If the implementation does not provide ASIDs, or software chooses to=
<br>
+\item If the implementation does not provide ASIDs and PPNs, or software c=
hooses to<br>
=C2=A0always use ASID 0, then after every {\tt satp} write, software should=
 execute<br>
=C2=A0SFENCE.VMA with {\em rs1}=3D{\tt x0}.=C2=A0 In the common case that n=
o global<br>
=C2=A0translations have been modified, {\em rs2} should be set to a registe=
r other than<br>
@@ -1003,13 +1091,14 @@ not flushed.<br>
<br>
=C2=A0\item If software modifies a non-leaf PTE, it should execute SFENCE.V=
MA with<br>
=C2=A0{\em rs1}=3D{\tt x0}.=C2=A0 If any PTE along the traversal path had i=
ts G bit set,<br>
-{\em rs2} must be {\tt x0}; otherwise, {\em rs2} should be set to the ASID=
 for<br>
-which the translation is being modified.<br>
+{\em rs2} must be {\tt x0}; otherwise, {\em rs2} should be set to the ASID=
 and<br>
+root page table&#39;s PPN for which the translation is being modified.<br>
<br>
=C2=A0\item If software modifies a leaf PTE, it should execute SFENCE.VMA w=
ith {\em<br>
=C2=A0rs1} set to a virtual address within the page.=C2=A0 If any PTE along=
 the traversal<br>
=C2=A0path had its G bit set, {\em rs2} must be {\tt x0}; otherwise, {\em r=
s2}<br>
-should be set to the ASID for which the translation is being modified.<br>
+should be set to the ASID and root page table&#39;s PPN for which the tran=
slation<br>
+is being modified.<br>
<br>
=C2=A0\item For the special cases of increasing the permissions on a leaf P=
TE and<br>
=C2=A0changing an invalid PTE to a valid leaf, software may choose to execu=
te<br>
-- <br>
2.7.4<br>
<br>
<br>
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-<br>
Links: You receive all messages sent to this group.<br>
<br>
View/Reply Online (#810): <a href=3D"https://lists.riscv.org/g/tech-privile=
ged/message/810" rel=3D"noreferrer" target=3D"_blank">https://lists.riscv.o=
rg/g/tech-privileged/message/810</a><br>
Mute This Topic: <a href=3D"https://lists.riscv.org/mt/34198986/1677273" re=
l=3D"noreferrer" target=3D"_blank">https://lists.riscv.org/mt/34198986/1677=
273</a><br>
Group Owner: <a href=3D"mailto:tech-privileged%2Bowner@lists.riscv.org" tar=
get=3D"_blank">tech-privileged+owner@lists.riscv.org</a><br>
Unsubscribe: <a href=3D"https://lists.riscv.org/g/tech-privileged/unsub" re=
l=3D"noreferrer" target=3D"_blank">https://lists.riscv.org/g/tech-privilege=
d/unsub</a>=C2=A0 [<a href=3D"mailto:andrew@sifive.com" target=3D"_blank">a=
ndrew@sifive.com</a>]<br>
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-<br>
<br>
</blockquote></div></div>

--000000000000d539180592ea1c65--

--===============4614402778956254927==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4614402778956254927==--
