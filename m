From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 0/8] arm64: Support for systems without AArch32 state
Date: Wed, 2 Mar 2016 15:24:30 +0000
Message-ID: <20160302152429.GE11670@leverpostej>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
 <20160301211923.GA1325@yury-N73SV>
 <20160302150721.GA16286@yury-N73SV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D253E41145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 10:17:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OhvkF6f24ZM1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2016 10:17:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECF50410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 10:17:27 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20160302150721.GA16286@yury-N73SV>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 02, 2016 at 06:07:21PM +0300, Yury Norov wrote:
> ubuntu@arm64:~$ uname -a
> Linux arm64 4.5.0-rc5-00019-g3e330b9 #76 SMP PREEMPT Wed Mar 2 17:46:57 MSK 2016 aarch64 aarch64 aarch64 GNU/Linux
> 
> ubuntu@arm64:~$ cat /proc/cpuinfo
> processor       : 0-47
> BogoMIPS        : 200.00
> Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics
> CPU implementer : 0x43
> CPU architecture: 8
> CPU variant     : 0x1
> CPU part        : 0x0a1
> CPU revision    : 0

As an aside, please do not hack up custom /proc/cpuinfo formats.

It is a compatibility nightmare for everyone.

Mark.
