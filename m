From: Peter Xu <peterx@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v4 08/11] libcflat: add IS_ALIGNED()
 macro, and page sizes
Date: Wed, 9 Nov 2016 10:07:05 -0500
Message-ID: <20161109150705.GA3762@pxdev.xzpeter.org>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
 <1478636499-14339-9-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36E3D4029B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2016 10:06:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2STXnyzDJHfq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2016 10:06:48 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7160540293
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2016 10:06:46 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1478636499-14339-9-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 08, 2016 at 09:21:36PM +0100, Andrew Jones wrote:
> From: Peter Xu <peterx@redhat.com>
> 
> These macros will be useful to do page alignment checks.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> [drew: also added SZ_64K]
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>
