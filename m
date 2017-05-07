From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 13/24] KVM: arm64: vgic-its: Check the device id
 matches TYPER DEVBITS range
Date: Sun, 07 May 2017 13:01:20 +0100
Message-ID: <871ss0lvu7.fsf@on-the-bus.cambridge.arm.com>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
 <1494084283-12723-14-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE20540B5B
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 07:58:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FNo3RnxLyeGW for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 May 2017 07:58:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00D1740BBC
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 07:58:21 -0400 (EDT)
In-Reply-To: <1494084283-12723-14-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Sat, 6 May 2017 17:24:32 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, Vijaya.Kumar@cavium.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, May 06 2017 at  4:24:32 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> On MAPD we currently check the device id can be stored in the device table.
> Let's first check it can be encoded within the range defined by TYPER
> DEVBITS.
>
> Also check the collection ID belongs to the 16 bit range as GITS_TYPER
> CIL field equals to 0.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
