From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [kvm-unit-tests PATCH] lib: arm: Use correct halt() prototype
 from smp.h
Date: Mon, 8 Apr 2019 10:00:31 -0700
Message-ID: <20190408170031.GE25880@linux.intel.com>
References: <20190408151125.32080-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D744A474
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 13:00:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5fLFEpBraR1W for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 13:00:33 -0400 (EDT)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06ADF4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 13:00:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190408151125.32080-1-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 08, 2019 at 04:11:25PM +0100, Alexandru Elisei wrote:
> The prototype for the halt() function is incorrect, because halt() doesn't
> take any arguments. Fix it by using the prototype from smp.h.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
