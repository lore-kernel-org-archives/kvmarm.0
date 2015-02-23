From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 4/5] KVM: arm/arm64: remove coarse grain dist locking
 at kvm_vgic_sync_hwstate
Date: Mon, 23 Feb 2015 21:38:45 +0100
Message-ID: <20150223203845.GE5609@cbox>
References: <1421685793-3547-1-git-send-email-eric.auger@linaro.org>
 <1421685793-3547-5-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF04466DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 15:32:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7rpS1OdQBJo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Feb 2015 15:32:39 -0500 (EST)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98426466DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 15:32:39 -0500 (EST)
Received: by lbdu10 with SMTP id u10so21049907lbd.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 12:38:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1421685793-3547-5-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 19, 2015 at 05:43:12PM +0100, Eric Auger wrote:
> To prepare for irqfd addition, coarse grain locking is removed at
> kvm_vgic_sync_hwstate level and finer grain locking is introduced in
> vgic_process_maintenance only.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
