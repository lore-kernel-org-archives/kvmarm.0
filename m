From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 12/13] KVM: arm: avoid binary number literals for gcc-4.2
Date: Wed, 4 Jan 2017 11:39:11 +0100
Message-ID: <20170104103911.GC20461@cbox>
References: <20161216105634.235457-1-arnd@arndb.de>
 <20161216105634.235457-13-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D00AC405E9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jan 2017 05:37:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VYjfUKbPBydF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Jan 2017 05:37:38 -0500 (EST)
Received: from mail-lf0-f49.google.com (mail-lf0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F048B400E9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jan 2017 05:37:37 -0500 (EST)
Received: by mail-lf0-f49.google.com with SMTP id d16so10556333lfb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Jan 2017 02:39:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161216105634.235457-13-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, kernel-build-reports@lists.linaro.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 16, 2016 at 11:56:33AM +0100, Arnd Bergmann wrote:
> Old gcc versions prior to 4.3 don't understand the 0b... syntax for
> numbers, and this seems to be the only instance in the kernel, so better
> use hexadecimal instead.
> 
> arch/arm/include/asm/kvm_mmu.h:127:38: error: invalid suffix "b101" on integer constant
> 
> Fixes: 159793001d7d ("ARM: KVM: force cache clean on page fault when caches are off")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Same as before:
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
