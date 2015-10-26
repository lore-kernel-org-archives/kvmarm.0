From: Christopher Covington <cov@codeaurora.org>
Subject: [kvm-unit-tests PATCHv5] ARM PMU tests
Date: Mon, 26 Oct 2015 11:38:47 -0400
Message-ID: <1445873930-9058-1-git-send-email-cov@codeaurora.org>
References: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com
Cc: shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Changes from v4:
* Add Drew's Reviewed-by to first patch.
* Explain use of 32-bit cycle count values in AArch32.
* Zero-initialize pmu_data struct before use in check_cycles_increase and check_cpi. While the insistence on not using memset is entirely my own vanity, I blame the funny syntax on https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119 (adds extra set of braces) and checkpatch (adds spaces).
* Improve formatting of inline assembly and better explain why so much code must be inline assembly.

