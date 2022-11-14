Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C574B256D
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 10:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AE4C433D6;
	Mon, 14 Nov 2022 10:18:50 +0000 (UTC)
Date: Mon, 14 Nov 2022 10:18:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 6/8] arm64/fpsimd: SME no longer requires SVE register
 state
Message-ID: <Y3IWB5enU2WMss9w@arm.com>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-7-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230321.1159287-7-broonie@kernel.org>

On Sat, Oct 22, 2022 at 12:03:19AM +0100, Mark Brown wrote:
> Now that we track the type of register state stored separately to
> tracking what is active in the task it is valid to have FPSIMD register
> state stored while in streaming mode so remove the special case handling
> for SME when setting FPSIMD register state.

I think this needs some punctuation as it is pretty hard to read.
Slightly adjusted, hopefully it keeps the same message:

  Now that we track the type of the stored register state separately to
  what is active in the task, it is valid to have the FPSIMD register
  state stored while in streaming mode. Remove the special case handling
  for SME when setting FPSIMD register state.

Otherwise,

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
