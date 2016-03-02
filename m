From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 3/4] pre_init: add support for i386 also
Date: Wed, 2 Mar 2016 02:57:58 +0000
Message-ID: <20160302025646.GA7637@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
 <1456327988-31568-4-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456327988-31568-4-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 24, 2016 at 03:33:07PM +0000, Andre Przywara wrote:
> Currently the pre_init support is provided only for x86_64. Since
> having 32-bit x86 supported as well is not far off, just add an
> implementation using i386 assembly instructions and the respective
> syscall ABI.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Makefile     |  1 +
>  x86/init32.S | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
>  create mode 100644 x86/init32.S

Did you manage to test this?

Will
