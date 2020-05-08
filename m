Return-Path: <SRS0=TDzU=6W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC16C47255
	for <kvmarm@archiver.kernel.org>; Fri,  8 May 2020 17:43:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89C732083B
	for <kvmarm@archiver.kernel.org>; Fri,  8 May 2020 17:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89C732083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9FE4B1BD;
	Fri,  8 May 2020 13:43:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cMxDBVEnJhwZ; Fri,  8 May 2020 13:43:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F6C54B194;
	Fri,  8 May 2020 13:43:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF7F44B194
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2020 13:43:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DznE7UA7HcKz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2020 13:43:08 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFDCD4B187
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2020 13:43:08 -0400 (EDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
 048HZWAC120545; Fri, 8 May 2020 13:42:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0b-001b2d01.pphosted.com with ESMTP id 30vtveutta-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 08 May 2020 13:42:43 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 048HaDP7122403;
 Fri, 8 May 2020 13:42:42 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.98])
 by mx0b-001b2d01.pphosted.com with ESMTP id 30vtveutsc-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 08 May 2020 13:42:42 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
 by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048HeoYq020104;
 Fri, 8 May 2020 17:42:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by ppma03ams.nl.ibm.com with ESMTP id 30s0g5wvbw-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Fri, 08 May 2020 17:42:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 048HgbZm43712600
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 8 May 2020 17:42:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id BBCB542041;
 Fri,  8 May 2020 17:42:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 6EED54203F;
 Fri,  8 May 2020 17:42:34 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.202.219])
 by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
 Fri,  8 May 2020 17:42:34 +0000 (GMT)
Date: Fri, 8 May 2020 20:42:32 +0300
From: Mike Rapoport <rppt@linux.ibm.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 02/14] arm: add support for folded p4d page tables
Message-ID: <20200508174232.GA759899@linux.ibm.com>
References: <20200414153455.21744-1-rppt@kernel.org>
 <20200414153455.21744-3-rppt@kernel.org>
 <CGME20200507121658eucas1p240cf4a3e0fe5c22dda5ec4f72734149f@eucas1p2.samsung.com>
 <39ba8a04-d6b5-649d-c289-0c8b27cb66c5@samsung.com>
 <20200507161155.GE683243@linux.ibm.com>
 <98229ab1-fbf8-0a89-c5d6-270c828799e7@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <98229ab1-fbf8-0a89-c5d6-270c828799e7@samsung.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216, 18.0.676
 definitions=2020-05-08_15:2020-05-08,
 2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 mlxscore=0
 suspectscore=1 spamscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080144
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Fenghua Yu <fenghua.yu@intel.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
 Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Jonas Bonn <jonas@southpole.se>, Brian Cain <bcain@codeaurora.org>,
 linux-hexagon@vger.kernel.org, linux-sh@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Ley Foon Tan <ley.foon.tan@intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 uclinux-h8-devel@lists.sourceforge.jp, linux-arch@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
 kvm-ppc@vger.kernel.org,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 openrisc@lists.librecores.org, Stafford Horne <shorne@gmail.com>,
 Guan Xuetao <gxt@pku.edu.cn>, linux-arm-kernel@lists.infradead.org,
 Christophe Leroy <christophe.leroy@c-s.fr>, Tony Luck <tony.luck@intel.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, nios2-dev@lists.rocketboards.org,
 Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org,
 Mike Rapoport <rppt@kernel.org>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, May 08, 2020 at 08:53:27AM +0200, Marek Szyprowski wrote:
> Hi Mike,
> =

> On 07.05.2020 18:11, Mike Rapoport wrote:
> > On Thu, May 07, 2020 at 02:16:56PM +0200, Marek Szyprowski wrote:
> >> On 14.04.2020 17:34, Mike Rapoport wrote:
> >>> From: Mike Rapoport <rppt@linux.ibm.com>
> >>>
> >>> Implement primitives necessary for the 4th level folding, add walks o=
f p4d
> >>> level where appropriate, and remove __ARCH_USE_5LEVEL_HACK.
> >>>
> >>> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> >> Today I've noticed that kexec is broken on ARM 32bit. Bisecting between
> >> current linux-next and v5.7-rc1 pointed to this commit. I've tested th=
is
> >> on Odroid XU4 and Raspberry Pi4 boards. Here is the relevant log:
> >>
> >> # kexec --kexec-syscall -l zImage --append "$(cat /proc/cmdline)"
> >> memory_range[0]:0x40000000..0xbe9fffff
> >> memory_range[0]:0x40000000..0xbe9fffff
> >> # kexec -e
> >> kexec_core: Starting new kernel
> >> 8<--- cut here ---
> >> Unable to handle kernel paging request at virtual address c010f1f4
> >> pgd =3D c6817793
> >> [c010f1f4] *pgd=3D4000041e(bad)
> >> Internal error: Oops: 80d [#1] PREEMPT ARM
> >> Modules linked in:
> >> CPU: 0 PID: 1329 Comm: kexec Tainted: G=A0=A0=A0=A0=A0=A0=A0 W
> >> 5.7.0-rc3-00127-g6cba81ed0f62 #611
> >> Hardware name: Samsung Exynos (Flattened Device Tree)
> >> PC is at machine_kexec+0x40/0xfc
> > Any chance you have the debug info in this kernel?
> > scripts/faddr2line would come handy here.
> =

> # ./scripts/faddr2line --list vmlinux machine_kexec+0x40
> machine_kexec+0x40/0xf8:
> =

> machine_kexec at arch/arm/kernel/machine_kexec.c:182
>  =A0177=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reboot_code_buffer =3D =

> page_address(image->control_code_page);
>  =A0178
>  =A0179=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Prepare parameters for reboot=
_code_buffer*/
>  =A0180=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 set_kernel_text_rw();
>  =A0181=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kexec_start_address =3D image->s=
tart;
>  >182<=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kexec_indirection_page =3D page_list;
>  =A0183=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kexec_mach_type =3D machine_arch=
_type;
>  =A0184=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kexec_boot_atags =3D image->arch=
.kernel_r2;
>  =A0185
>  =A0186=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* copy our kernel relocation co=
de to the control code =

> page */
>  =A0187=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reboot_entry =3D fncpy(reboot_co=
de_buffer,

Can you please try the patch below:

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 963b5284d284..f86b3d17928e 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -571,7 +571,7 @@ static inline void section_update(unsigned long addr, p=
mdval_t mask,
 {
 	pmd_t *pmd;
 =

-	pmd =3D pmd_off_k(addr);
+	pmd =3D pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, addr), addr), add=
r), addr);
 =

 #ifdef CONFIG_ARM_LPAE
 	pmd[0] =3D __pmd((pmd_val(pmd[0]) & mask) | prot);

>  > ...
> =

> Best regards
> -- =

> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> =


-- =

Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
