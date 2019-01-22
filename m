From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH kvmtool v2 00/13] Implement reset of virtio devices
Date: Tue, 22 Jan 2019 07:07:30 +0000
Message-ID: <20190122070729.GA10214@brain-police>
References: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CE484A3A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 02:07:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TIhU0Z26ksgt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 02:07:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1593A4A397
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 02:07:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1547129570-14351-1-git-send-email-julien.thierry@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kraxel@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 10, 2019 at 02:12:37PM +0000, Julien Thierry wrote:
> This series was developped by Jean-Philippe and is needed for a series
> I'll be posting shortly after to load firmwares on arm kvmtool.
> 
> Currently, when a guest tries to reset a device, a lot of ressources
> aren't reset (threads keep running, virtio queue keep their state, etc).
> 
> When the guest only does the reset to initialize the device and there
> were no previous users, there is no noticeable issue. But when a guest
> has a firmare + Linux, if the firmware uses a virtio device, Linux will
> fail to probe that device.
> 
> This series aim to properly reset the virtio resources when the guests
> requests it.
> 
> Reset of net vhost is unsupported for now.
> 
> Patch 1 is a bug fix on ioeventfd
> Patch 2-6 provide the core support so devices can implement their reset
> Patch 7-13 implements the reset for the various virtio devices

Cheers, I'll pick this up. There's a vague comment in patch 10 about aio
being busted. If that's the case then we should either fix it or remove
it...

Will
