From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v13 10/12] qdev: check callback takes the
 property child as third argument
Date: Wed, 29 Apr 2015 13:12:24 +0200
Message-ID: <5540BC98.1010608@redhat.com>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
	<1430239873-31950-11-git-send-email-eric.auger@linaro.org>
	<554094DF.3010607@redhat.com> <55409830.30303@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <55409830.30303@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, agraf@suse.de, peter.crosthwaite@xilinx.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 29/04/2015 10:37, Eric Auger wrote:
>> > This should be an unref.
> oups yes.
> 
> Thanks! Do I keep this series or do I revert to sysbus irq connect irq
> temporary patch as per Peter's last email?

I think reverting is better since you need a respin and Peter offered to
touch the code later.

Paolo
