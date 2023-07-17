Received: from out-2.mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5863F1FCC
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 06:52:21 +0000 (UTC)
Date: Mon, 17 Jul 2023 08:52:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689576739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gapnKSXecBhafBmY3IK8nOAfs/SnQT5bOWVQ5MjDLt4=;
	b=cpiJOcEM5sDXtMI7/DND2y8Asg4Mo+i4+4TQsvpe0ymlacFZOH03kAC1ymtTy20d2HzmKM
	S1acpxyjjLIIMf67r4QyhgA63djeS2bjVIq1SrxKsnngGdNV1BPbsU+1lnjrQsvpHwICGt
	ekilKoyPH7rG34LOHFI47bSuLbRTOZQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <namit@vmware.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Message-ID: <20230717-085f1ee1d631f213544fed03@orel>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
 <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
 <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
 <57A6ABC7-8A95-4199-92E3-FA4D89D6705F@vmware.com>
 <20230717-52b1cacc323e5105506e5079@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230717-52b1cacc323e5105506e5079@orel>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 17, 2023 at 08:50:30AM +0200, Andrew Jones wrote:
> On Fri, Jul 14, 2023 at 06:42:25PM +0000, Nadav Amit wrote:
> > 
> > 
> > > On Jul 14, 2023, at 4:29 AM, Shaoqin Huang <shahuang@redhat.com> wrote:
> > > 
> > > !! External Email
> > > 
> > > Hi,
> > > 
> > > On 7/14/23 18:31, Alexandru Elisei wrote:
> > >> Hi,
> > >> 
> > >> On Sat, Jun 17, 2023 at 01:31:37AM +0000, Nadav Amit wrote:
> > >>> From: Nadav Amit <namit@vmware.com>
> > >>> 
> > >>> Do not assume PAN is not supported or that sctlr_el1.SPAN is already set.
> > >> 
> > >> In arm/cstart64.S
> > >> 
> > >> .globl start
> > >> start:
> > >>         /* get our base address */
> > >>      [..]
> > >> 
> > >> 1:
> > >>         /* zero BSS */
> > >>      [..]
> > >> 
> > >>         /* zero and set up stack */
> > >>      [..]
> > >> 
> > >>         /* set SCTLR_EL1 to a known value */
> > >>         ldr     x4, =INIT_SCTLR_EL1_MMU_OFF
> > >>      [..]
> > >> 
> > >>         /* set up exception handling */
> > >>         bl      exceptions_init
> > >>      [..]
> > >> 
> > >> Where in lib/arm64/asm/sysreg.h:
> > >> 
> > >> #define SCTLR_EL1_RES1  (_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
> > >>                          _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
> > >> #define INIT_SCTLR_EL1_MMU_OFF  \
> > >>                         SCTLR_EL1_RES1
> > >> 
> > >> Look like bit 23 (SPAN) should be set.
> > >> 
> > >> How are you seeing SCTLR_EL1.SPAN unset?
> > > 
> > > Yeah. the sctlr_el1.SPAN has always been set by the above flow. So Nadav
> > > you can describe what you encounter with more details. Like which tests
> > > crash you encounter, and how to reproduce it.
> > 
> > I am using Nikos’s work to run the test using EFI, not from QEMU.
> > 
> > So the code that you mentioned - which is supposed to initialize SCTLR -
> > is not executed (and actually not part of the EFI image).
> > 
> > Note that using EFI, the entry point is _start [1], and not “start”.
> > 
> > That is also the reason lack of BSS zeroing also caused me issues with the
> > EFI setup, which I reported before.
> 
> Nadav,
> 
> Would you mind reposting this along with the BSS zeroing patch, the
> way I proposed we do that, and anything else you've discovered when
> trying to use the EFI unit tests without QEMU? We'll call that our
> first non-QEMU EFI support series, since the first EFI series was
> only targeting QEMU.

Oh, and I meant to mention that, when reposting this patch, maybe we
can consider managing sctlr in a similar way to the non-efi start path?

Thanks,
drew
