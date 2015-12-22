From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] Add a rudimentary manpage
Date: Tue, 22 Dec 2015 15:11:13 +0000
Message-ID: <20151222151113.GI32623@arm.com>
References: <1450792847-1783-1-git-send-email-andre.przywara@arm.com>
 <1450792847-1783-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42B4548912
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 10:08:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uQC1+XUdHMJ3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 10:08:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C3E2412ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 10:08:31 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1450792847-1783-2-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: dimitri.j.ledkov@intel.com, sasha.levin@oracle.com, penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre, of Phoronix fame,

On Tue, Dec 22, 2015 at 02:00:46PM +0000, Andre Przywara wrote:
> The kvmtool documentation is somewhat lacking, also it is not easily
> accessible when living in the source tree only.
> Add a good ol' manpage to document at least the basic commands and
> their options.
> This level of documentation matches the one that is already there in
> the Documentation directory and should be subject to extension.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Documentation/kvmtool.1 | 222 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 222 insertions(+)
>  create mode 100644 Documentation/kvmtool.1
> 
> diff --git a/Documentation/kvmtool.1 b/Documentation/kvmtool.1
> new file mode 100644
> index 0000000..aecb2dc
> --- /dev/null
> +++ b/Documentation/kvmtool.1
> @@ -0,0 +1,222 @@
> +.\" Manpage for kvmtool
> +.\" Copyright (C) 2015 by Andre Przywara <andre.przywara@arm.com>
> +.TH kvmtool 1 "11 Nov 2015" "0.1" "kvmtool man page"
> +.SH NAME
> +kvmtool \- running KVM guests
> +.SH SYNOPSIS
> +lkvm COMMAND [ARGS]
> +.SH DESCRIPTION
> +kvmtool is a userland tool for creating and controlling KVM guests.
> +.SH "KVMTOOL COMMANDS"
> +.sp
> +.PP
> +.B run -k <kernel-image> ...

You seem to be inconsistent with your synopses for each command. That is,
here you just have -k <kernel-image> ... , but later you have things like

> +.B debug --all|--name <guest name> [--dump] [--nmi <n>] [--sysrq <rq>]

which describes all of the possible options to debug. I think I prefer
this latter way, so could you make all of the commands look like that,
please?

Will
