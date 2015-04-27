From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v11 0/4] machvirt dynamic sysbus device instantiation
Date: Mon, 27 Apr 2015 16:02:16 +0200
Message-ID: <553E4168.7090307@suse.de>
References: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>	<CAN9JPjHCMPeY=zouEd=aP_mGQriLfv7q4gTK0Y+DW2K76c9qyA@mail.gmail.com>	<55390D15.2060909@linaro.org>
 <CAN9JPjEZ6RwHT2rSei_toOBGUB7Dipne_hxek1QO4LkWceirHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF5264E994
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 09:55:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MmRgpOwU52Zs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 09:55:50 -0400 (EDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C30B4E98C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 09:55:50 -0400 (EDT)
In-Reply-To: <CAN9JPjEZ6RwHT2rSei_toOBGUB7Dipne_hxek1QO4LkWceirHg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Baptiste Reynal <b.reynal@virtualopensystems.com>, Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, patches@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/24/2015 09:36 AM, Baptiste Reynal wrote:
> I think it will be a pity to postpone VFIO support on QEMU and would
> rather introduce the support for VIRT_MMIO later.
>
> Alex, what is your position on it ?

Ah, sorry, I read this mail too late. Converting virtio-mmio to a 
dynamic sysbus device should be trivial after Eric's enablement. It's 
basically the same as the calxeda nic driver, just that this time around 
we're spawning the virtio-mmio bridge devices.


Alex
