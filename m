Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF75D7F
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 04:01:46 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 519A91FB;
	Mon, 12 Jun 2023 21:02:25 -0700 (PDT)
Received: from [10.162.42.9] (unknown [10.162.42.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCA513F587;
	Mon, 12 Jun 2023 21:01:36 -0700 (PDT)
Message-ID: <4fec9cf7-b4b6-c5c1-7db5-493240c54ef1@arm.com>
Date: Tue, 13 Jun 2023 09:31:13 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH V2 12/14] arm64/sysreg: Convert TRBMAR_EL1 register to
 automatic generation
Content-Language: en-US
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Rob Herring <robh@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, kvmarm@lists.linux.dev, coresight@lists.linaro.org,
 linux-kernel@vger.kernel.org
References: <20230602062552.565992-1-anshuman.khandual@arm.com>
 <20230602062552.565992-13-anshuman.khandual@arm.com>
 <8a352dec-9655-4e7c-ba35-1c48e154bc71@sirena.org.uk>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <8a352dec-9655-4e7c-ba35-1c48e154bc71@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/2/23 17:35, Mark Brown wrote:
> On Fri, Jun 02, 2023 at 11:55:50AM +0530, Anshuman Khandual wrote:
> 
>> +Sysreg	TRBMAR_EL1	3	0	9	11	4
>> +Res0	63:12
>> +Field	11:10	PAS
>> +Field	9:8	SH
>> +Field	7:0	Attr
>> +EndSysreg
> 
> PAS and SH look like they should be enums, Attr is a bit more complex so
> Field is probably a good fit there.  Adding the enum information could
> be done incrementally though so:

Will fold the following changes in this patch.

--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2246,8 +2246,17 @@ EndSysreg
 
 Sysreg TRBMAR_EL1      3       0       9       11      4
 Res0   63:12
-Field  11:10   PAS
-Field  9:8     SH
+Enum   11:10   PAS
+       0b00    SECURE
+       0b01    NON_SECURE
+       0b10    ROOT
+       0b11    REALM
+EndEnum
+Enum   9:8     SH
+       0b00    NON_SHAREABLE
+       0b10    OUTER_SHAREABLE
+       0b11    INNER_SHAREABLE
+EndEnum
 Field  7:0     Attr
 EndSysreg

> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
