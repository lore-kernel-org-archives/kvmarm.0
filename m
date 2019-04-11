From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v13 8/8] arm64: docs: document perf event attributes
Date: Thu, 11 Apr 2019 18:18:48 +0100
Message-ID: <20190411171848.GG29081@fuggles.cambridge.arm.com>
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-9-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F904A484
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Apr 2019 13:18:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Kn7Wmzv8+qT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Apr 2019 13:18:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774064A46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Apr 2019 13:18:53 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190409192217.23459-9-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 09, 2019 at 08:22:17PM +0100, Andrew Murray wrote:
> The interaction between the exclude_{host,guest} flags,
> exclude_{user,kernel,hv} flags and presence of VHE can result in
> different exception levels being filtered by the ARMv8 PMU. As this
> can be confusing let's document how they work on arm64.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  Documentation/arm64/perf.txt | 85 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 Documentation/arm64/perf.txt

Thanks! Hopefully I no longer have to try (and fail) to figure out these
semantics from the code anymore...

Acked-by: Will Deacon <will.deacon@arm.com>

Will
