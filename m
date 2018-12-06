From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 24/25] firmware: arm_sdei: Add ACPI GHES registration
 helper
Date: Thu, 6 Dec 2018 16:18:45 +0000
Message-ID: <20181206161844.GO54495@arrakis.emea.arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-25-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B25E74A2FB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 11:18:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zfITIO7fLoxu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Dec 2018 11:18:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE584A1DF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 11:18:50 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-25-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Rafael Wysocki <rjw@rjwysocki.net>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 06:06:12PM +0000, James Morse wrote:
> APEI's Generic Hardware Error Source structures do not describe
> whether the SDEI event is shared or private, as this information is
> discoverable via the API.
> 
> GHES needs to know whether an event is normal or critical to avoid
> sharing locks or fixmap entries, but GHES shouldn't have to know about
> the SDEI API.
> 
> Add a helper to register the GHES using the appropriate normal or
> critical callback.
> 
> Signed-off-by: James Morse <james.morse@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
