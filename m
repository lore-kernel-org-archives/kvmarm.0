From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 11/11] KVM: arm64: add trace points for guest_debug
 debug
Date: Wed, 8 Jul 2015 12:03:02 +0200
Message-ID: <20150708100302.GE13530@cbox>
References: <1436286603-15192-1-git-send-email-alex.bennee@linaro.org>
 <1436286603-15192-12-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8DCD58075
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 05:51:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8VmStSfqPW3l for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 05:51:26 -0400 (EDT)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
 [209.85.215.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 250EF58073
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 05:51:25 -0400 (EDT)
Received: by lagx9 with SMTP id x9so221746307lag.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jul 2015 03:02:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436286603-15192-12-git-send-email-alex.bennee@linaro.org>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 07, 2015 at 05:30:03PM +0100, Alex Benn=E9e wrote:
> This includes trace points for:
>   kvm_arch_setup_guest_debug
>   kvm_arch_clear_guest_debug
> =

> I've also added some generic register setting trace events and also a
> trace point to dump the array of hardware registers.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>

Seems like a lot of traces, but I guess that doesn't hurt anything:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
