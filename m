From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 0/6] arm: Add support for firmware booting
Date: Thu, 10 Jan 2019 14:20:40 +0000
Message-ID: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F0ED4A47B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:20:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2VMPw7tYq2fM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:20:54 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07FB34A476
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:20:53 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This series is based on the virtio reset series[1] posted earlier.

We would like to be able to load firmwares like UEFI in kvmtool.

The series contains:
A way to load the firmware into RAM and an option to be able to create
non-volatile memory zones and load data into them.

Those non-volatile memory are presented throught the DT with a node:

	<flash>@<addr> {
		compatible = "kvmtool,flash";
		reg = < <addr> <size> >;
		label = <name>;
	}

These are expected to be dealt with by specific kvmtool driver and not
to be picked up by existing drivers (although technically it is just
plain memory, mapped in the guest).


Changes since v1[2]:
* Added Andre's Reviewed-by tags.
* Changed the DT binding for nvmem.
* removed the requirement to provide firmware load address (defaults to
  the start of RAM).

[1] https://marc.info/?l=kvm&m=154712959125764&w=2
[2] https://marc.info/?l=kvm&m=154392208726108&w=2

Cheers,

Julien

-->

Julien Thierry (5):
  arm: Move firmware function
  builtin-run: Do not look for default kernel when firmware is provided
  arm: Support firmware loading
  kvm: Add arch specific reset
  arm: Support non-volatile memory

Sami Mujawar (1):
  rtc: Initialize the Register D for MC146818 RTC

 arm/fdt.c                                |  58 +++++++--
 arm/include/arm-common/kvm-arch.h        |   5 +-
 arm/include/arm-common/kvm-config-arch.h |  21 +++-
 arm/kvm.c                                | 207 +++++++++++++++++++++++++++++++
 builtin-run.c                            |  24 ++--
 hw/rtc.c                                 |   8 ++
 include/kvm/kvm.h                        |   1 +
 kvm.c                                    |   2 +
 mips/kvm.c                               |   4 +
 powerpc/kvm.c                            |   4 +
 x86/kvm.c                                |   4 +
 11 files changed, 317 insertions(+), 21 deletions(-)

--
1.9.1
