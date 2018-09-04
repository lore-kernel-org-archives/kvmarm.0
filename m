From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH kvm-unit-tests v2 0/2] Support micro operation
 measurement on arm64
Date: Tue, 4 Sep 2018 15:30:05 +0200
Message-ID: <20180904133005.GQ4029@e113682-lin.lund.arm.com>
References: <20180903122002.569-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D7B849F89
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 09:30:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NryFl9s834a6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Sep 2018 09:30:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ED2540A6E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Sep 2018 09:30:08 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180903122002.569-1-drjones@redhat.com>
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
Cc: marc.zyngier@arm.com, ynorov@caviumnetworks.com, shihwei@cs.columbia.edu, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 03, 2018 at 02:20:00PM +0200, Andrew Jones wrote:
> I dropped the version numbers, but this is v4 of Shih-Wei Li's series of
> the same name, last posted in January. I took the liberty of
> incorporating all the comments v3 had, plus making some other cleanup
> tweaks. These tests are too nice to let them slip away, let's get them
> reviewed and merged.
> 
> v2:
>  - add missing 'L' in 'UL' for PS_PER_SEC. There's a lot of picoseconds
>    in a second!

Numbers look more sane now indeed :)

Tested-by: Christoffer Dall <christoffer.dall@arm.com>

Thanks,

    Christoffer
