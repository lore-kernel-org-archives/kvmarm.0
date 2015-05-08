From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 00/12] KVM Guest Debug support for arm64
Date: Fri, 8 May 2015 18:33:05 +0200
Message-ID: <20150508163305.GJ24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4621F50E30
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 12:24:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S-Bf4eAU6JXC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2015 12:24:10 -0400 (EDT)
Received: from mail-lb0-f178.google.com (mail-lb0-f178.google.com
 [209.85.217.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40D8850E8C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 12:24:09 -0400 (EDT)
Received: by lbbuc2 with SMTP id uc2so56828417lbb.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 May 2015 09:33:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 06, 2015 at 05:23:15PM +0100, Alex Benn=E9e wrote:
> Hi,
> =

> Here is V3 of the KVM Guest Debug support for arm64.
> =

> This sees the return of hyp.S re-factoring code which has been
> expanded to handle both the save and restore legs. The HW debug patch
> then adds a simple indirection to enable switching between the guest
> context debug registers and the active debugging context.
> =

> The API has been further simplified to remove the PC (as that is
> already available by the GET_ONE_REG ioctl). The responsibility for
> handling re-injection is now explicitly that of userspace.
> =

> The setup/clear debug code has gained an init function to be called at
> start-up and save useful values (currently only mdcr_el2.HPMN).
> =

> For full details see the changelog on each of the patches.
> =

> As before there are a few checkpatch violations for white space. Some
> in existing code (asm-offsets) and a couple in the handle_exit code
> where adding a whole extra tab seemed excessive.
> =

> Reviewed-by tags have been added to the earlier patches as
> appropriate.
> =

> GIT Repos:
> =

> The patches for this series are based off v4.1-rc1 and can be found
> at:
> =

> https://git.linaro.org/people/alex.bennee/linux.git
> branch: guest-debug/4.1-rc1-v3
> =


This doesn't seem to build for 32-bit ARM :(

-Christoffer
