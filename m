From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 00/11] KVM Guest Debug support for arm64
Date: Thu, 9 Jul 2015 11:53:23 +0200
Message-ID: <20150709095323.GF13530@cbox>
References: <1436286603-15192-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBE5C582D3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 05:41:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zSINDkSlmYBp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 05:41:45 -0400 (EDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
 [209.85.217.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB08A582CB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 05:41:44 -0400 (EDT)
Received: by lbnk3 with SMTP id k3so71853771lbn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 02:53:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436286603-15192-1-git-send-email-alex.bennee@linaro.org>
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

On Tue, Jul 07, 2015 at 05:29:52PM +0100, Alex Benn=E9e wrote:
> Here is V8 of the KVM Guest Debug support for arm64.
> =

> The diffstat between v7 and v8 is getting pretty small and as I
> haven't re-based you can run:
> =

>         git diff -u guest-debug/4.1-v7..guest-debug/4.1-v8
> =

> And the kernelci report is at:
> =

>         http://kernelci.org/build/alex/kernel/v4.1-11-g182a5fa64600/
> =

> =

> The only real changes apart from comments and white space are to
> sys_regs which sees another minor re-factoring. The 32 bit handling
> explicitly preserves the top 32 bits of the AArch64 registers although
> I'm not convinced it matter too much as for a booting AArch32 guest
> kernel they should start as 0 and never change.
> =

> For full details see the changelog on each of the patches.
> =

> GIT Repos:
> =

> The patches for this series are based off v4.1 and can be found
> at:
> =

> Kernel:
> https://git.linaro.org/people/alex.bennee/linux.git
> branch: guest-debug/4.1-v8
> describe: v4.1-11-g182a5faB
> =

> QEMU:
> https://github.com/stsquad/qemu
> branch: kvm/guest-debug-v6*** BLURB HERE ***
> =

> =

I'm happy with this series as it stands now and think it can be put into
-next.

I have boot-tested the series with a VM on both Juno and TC2.

Thanks,
-Christoffer
