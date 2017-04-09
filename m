From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 14/22] KVM: arm64: ITS: vgic_its_alloc_ite/device
Date: Sun, 09 Apr 2017 11:13:57 +0100
Message-ID: <86d1clc2hm.fsf@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-15-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA95040D85
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Apr 2017 06:11:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H-unaZlEtoEG for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Apr 2017 06:11:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C672F40D7A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Apr 2017 06:11:43 -0400 (EDT)
In-Reply-To: <1490607072-21610-15-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Mon, 27 Mar 2017 11:31:04 +0200")
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
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27 2017 at 10:31:04 AM, Eric Auger <eric.auger@redhat.com> wrote:
> Add two new helpers to allocate an its ite and an its device.
> This will avoid duplication on restore path.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
