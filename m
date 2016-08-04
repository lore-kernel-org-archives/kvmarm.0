From: Matthias Brugger <mbrugger@suse.com>
Subject: arm64: Implement IPI based TLB invalidation
Date: Thu,  4 Aug 2016 11:15:13 +0200
Message-ID: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com
Cc: suzuki.poulose@arm.com, james.morse@arm.com, david.daney@cavium.com, rrichter@cavium.com, agraf@suse.de, mbrugger@suse.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com, dave.long@linaro.org, ard.biesheuvel@linaro.org, zlim.lnx@gmail.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch set adds a workaround for arm64 if the hardware didn't
implement the TLB invalidation via broadcast TLBI properly.
