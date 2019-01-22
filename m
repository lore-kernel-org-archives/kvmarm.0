From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH kvmtool v2 0/6] arm: Add support for firmware booting
Date: Tue, 22 Jan 2019 07:10:26 +0000
Message-ID: <20190122071024.GB10214@brain-police>
References: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A994A3A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 02:10:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NOealGMBFrnh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 02:10:32 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D444A376
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 02:10:32 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: andre.przywara@arm.com, Sami.Mujawar@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Julien,

On Thu, Jan 10, 2019 at 02:20:40PM +0000, Julien Thierry wrote:
> This series is based on the virtio reset series[1] posted earlier.
> 
> We would like to be able to load firmwares like UEFI in kvmtool.
> 
> The series contains:
> A way to load the firmware into RAM and an option to be able to create
> non-volatile memory zones and load data into them.
> 
> Those non-volatile memory are presented throught the DT with a node:
> 
> 	<flash>@<addr> {
> 		compatible = "kvmtool,flash";
> 		reg = < <addr> <size> >;
> 		label = <name>;
> 	}
> 
> These are expected to be dealt with by specific kvmtool driver and not
> to be picked up by existing drivers (although technically it is just
> plain memory, mapped in the guest).

I've picked up the first four patches of this series, but I don't really
understand where you're going with the non-volatile memory part and whether
it's nvram, flash or something completely different. Given that Linux
doesn't support your binding, is this something that UEFI currently uses?

Will
